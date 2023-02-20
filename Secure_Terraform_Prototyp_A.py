import subprocess
import io
import pypandoc
import panflute
from chatgpt_wrapper import ChatGPT
import json
import os
from pypandoc.pandoc_download import download_pandoc
import shutil

# Usage:
#   -If you want to use one of the prompts in the list prompts just remove the # in front on the prompt
#   -If you want to use your own description of a terraform configuration add it to the prompts list below

# In theory it is possible to generate output for the whole list but normally chatgpt will start to block you
# if you do more then one prompt
# 
# The results of the generation will be save in the data/results folder
# The results not only consist of the Terraform script but also one json per request that was sent to chatgpt

prompts = [
     {"id": 1, "prompt": "Can you deploy an AWS EC2 instance."},
     {"id": 2, "prompt": "Can you create a VPC gateway instance with elastic IP on AWS?"},
     {"id": 3, "prompt": "Can you create a S3 Bucket on AWS?"},
     {"id": 4, "prompt": "Can you provision a t2.micro instance on AWS?"},
     {"id": 5, "prompt": "Can you deploy a web server with a public IP on AWS?"},
     {"id": 6, "prompt": "Can you change the AMI of an AWS EC2 instance to Ubuntu 16.04?"},
]

# These strings get concatinated in from of the prompt in order to get the output we want
settingsPrompts = [
    "Can you create terraform configuration code in the following?",
    "Don't forget the starting terraform block.",
    "Only print out a single code block per response.",
    "Fill any placeholders with dummy values.",
    "The code should be generated based on the following description."
]


# extract code extracts the code from a the mardown file we get from chatgpt
def extract_code(file_name: str) -> list[str]:
    def action(elem, doc):
        if isinstance(elem, panflute.CodeBlock):
            doc.code.append(elem)

    def prepare(doc):
        doc.code = []

    data = pypandoc.convert_file('tmp/chatgpt.md', 'json')
    doc = panflute.load(io.StringIO(data))
    doc = panflute.run_filter(action, prepare=prepare, doc=doc)
    return [code.text for code in doc.code]


# initializes folder structure needed
def initFolders():
    # generate tmp folder if it does not exist
    if not os.path.exists("tmp"):
        print("create tmp folder")
        os.makedirs("tmp")

    # generate prompts and data folder if they do not exist
    if not os.path.exists("data/results"):
        print("create prompts folder")
        os.makedirs("data/results")


# gets repsone from chatgpt and saves it into the .md and .tf file in tmp
def getResponse(prompt: str):
    if debug:
        print(f"### PROMPT: \n{prompt}")
        print("Waiting for response ... ")

    # get the reponse from chatgpt
    response = bot.ask(prompt)

    if debug:
        print("ChatGPT: \n", response)

    # save reponse into a temporary markdown file
    if os.path.exists("tmp/chatgpt.md"):
        os.remove("tmp/chatgpt.md")
    f = open("tmp/chatgpt.md", "w+")
    f.write(response)
    f.close()

    code = "\n".join(extract_code(response))
    
    # if code is an empty string we do not overwrite the old code and return the empty string
    if code == "":
        return code

    # overwrite the old tf file
    if os.path.exists("tmp/chatgpt.tf"):
        os.remove("tmp/chatgpt.tf")
    f = open(f"tmp/chatgpt.tf", "w+")
    f.write(code)
    f.close()

    return code

def runTfSec():
    # Run tfsec on the current tf file in the tmp folder
    result = subprocess.run(["tfsec", f"tmp/", "-f", "json"], capture_output=True)
    
    # check if tfsec returned a proper json  if not it failed
    try:
        tfSecOutput = json.loads(result.stdout.decode("utf-8"))
    except:
        tfSecOutput = "error"

    return tfSecOutput

# saves the final code and data list
def finish(code, data, attempt, id):
    f = open(f"data/results/prompt_{id}.tf", "w+")
    f.write(code)
    f.close()

    f = open(f"data/results/prompt_{id}.json", "w+")
    f.write(json.dumps(data))
    f.close()

    
#this method takes a prompt and tries to generate a secure tf script
def computePrompt(p):
    id, prompt = p.values()
    prompt = " ".join(settingsPrompts) + "\n" + prompt
    
    # this list saves the prompt and outputs made in the process
    data = []
    stopped = False

    for attempt in range(5):
        # get the code from the current prompt
        code = getResponse(prompt)

        # if there is an empty string returned this means chatgpt didn't give back a code block
        if code == "":
            if debug:
                print("Chatgpt didn't give another code example")
            
            # we set code to the last version of the code
            f =  open("tmp/chatgpt.tf", "r")
            code = f.read()
            f.close()

            # append a new object that shows that chatgpt stopped generating code
            data.append({
            "prompt": str(prompt),
            "code": "no code from chatgpt",
            "tfsec": "",
            "number_of_issues": number_of_issues
            })

            finish(code, data, attempt, id)
            stopped = True
            break


        tfSecOutput = runTfSec()

        # if tfSecOutput is "error" this means tfsec had some kind of error while executing
        if tfSecOutput == "error":
            if debug:
                print("Tfsec threw and error")

            # append a new object that shows that tfsec threw an error
            data.append({
            "prompt": str(prompt),
            "code": str(code),
            "tfsec": "Tfsec threw an error",
            "number_of_issues": ""
            })

            finish(code, data, attempt, id)
            stopped = True
            break

        # stores number of vulnerabilities found in tf file
        if tfSecOutput["results"] == None:
            number_of_issues = 0
        else:
            number_of_issues = len(tfSecOutput["results"])

        if debug:
            print(f"Detected {number_of_issues} issues")

        # updates data list
        data.append({
            "prompt": str(prompt),
            "code": str(code),
            "tfsec": str(json.dumps(tfSecOutput)),
            "number_of_issues": str(number_of_issues)
        })
        
        # if number_of_issues == 0 we have no vulerabilities left in our code and we can stop
        if number_of_issues == 0:
            if debug:
                print("All vulnerabilities have been resolved.")

            finish(code, data, attempt, id)
            stopped = True
            break
        
        # else we continue trying to fix the remaining issues
        else:
            
            # getting the new prompt with all the issues
            prompt = code + "\n" + "My code has the following security vulnerabilities. Can you fix this and " \
                                            "print out the full code?\n"
            
            for i, issue in enumerate(tfSecOutput["results"]):
                prompt = prompt + "Vulnerablitity " + str(i) + ":\n"
                prompt = prompt + str(issue) + "\n"
    
    if not stopped:
        f = open(f"data/results/prompt_{id}.tf", "w+")
        f.write(code)
        f.close()


debug = True
bot = ChatGPT()

basepath = "E:/Dokumente/Uni/Praktikum/TerraformSecurity-Analysis"

response = bot.ask("Hello")
if not (response == 'Your ChatGPT session is not usable.\n* Run this program with the `install` parameter and log in to ChatGPT.\n* If you think you are already logged in, try running the `session` command.'):
    initFolders()

    for sample in range(50):
        for i, p in enumerate(prompts):
            computePrompt(p)
            bot.new_conversation()
            os.mkdir(f"{basepath}/data/prototype_A_results/prompt{i+1}/sample{sample}")
            shutil.move(f"{basepath}/data/results/prompt_{i+1}.tf", f"{basepath}/data/prototype_A_results/prompt{i+1}/sample{sample}/prompt_{i+1}.tf")
            shutil.move(f"{basepath}/data/results/prompt_{i+1}.json", f"{basepath}/data/prototype_A_results/prompt{i+1}/sample{sample}/prompt_{i+1}.json")     


    if os.path.exists("tmp/chatgpt.md"):
        os.remove("tmp/chatgpt.md")
    
    if os.path.exists("tmp/chatgpt.tf"):
        os.remove("tmp/chatgpt.tf")
    
    if os.path.exists("tmp"):
        os.removedirs("tmp")
else:
    print("ChatGPT is not working")