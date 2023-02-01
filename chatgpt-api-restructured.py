import subprocess
import io
import pypandoc
import panflute
from chatgpt_wrapper import ChatGPT
import json
import os
from pypandoc.pandoc_download import download_pandoc


# Here are all the different prompts we tested
prompts = [
    # {"id": 1, "prompt": "Can you deploy an AWS EC2 instance."},
    # {"id": 2, "prompt": "Can you create a VPC gateway instance with elastic IP on AWS?"},
    # {"id": 3, "prompt": "Can you create a S3 Bucket on AWS?"},
    # {"id": 4, "prompt": "Can you provision a t2.micro instance on AWS?"},
     {"id": 5, "prompt": "Can you deploy a web server with a public IP on AWS?"},
    # {"id": 6, "prompt": "Can you change the AMI of an AWS EC2 instance to Ubuntu 16.04?"},
    # bucket_bucket_object
    # {"id": 7, "prompt": "Provider Block with region us-east-1. Create S3 Bucket Resource. Set bucket to cookie. Resource, aws s3 bucket object. Set key to index.html and use the s3 bucket id."},
    # data_ami-instance
    # {"id": 8, "prompt": "Provider AWS block with region set to us-east-1. data block: Get latest AMI ID for Amazon Linux2 OS. Create AWS instance with data ami id and t2.micro"},
    #instance-output-dns
    # {"id": 9, "prompt": "Provider AWS block with region us east. Create EC2 Instance with ami-0ff8a91507f77f867 and t2.micro. Output block, create public DNS URL from vm."},
    # random_pet-bucket
    # {"id": 10, "prompt": "AWS provider block in region us-east-1. Resource block to create a random pet name of length 5 with separator - . Resource Block: Create AWS S3 Bucket with bucket set as random pet name."},
    # security_ssh-instance
    # {"id": 11, "prompt": "Provider AWS in region "us-east-1". Create Security Group that allows port 22 inbound and all outbound ports. Create EC2 Instance with ami-0915bcb5fa77e4892 and instance type t3.micro. Use vpc ssh security group id."},
    # variable_instance
    # {"id": 12, "prompt": "AWS provider block in region us-east-1. Create Security Group called vpc-ssh. It allows port 22 ingress and all ports and ip egress."},
    # vpc-gateway-instance-eip
    # {"id": 13, "prompt": "Provider Block. Create a AWS VPC resource. AWS Internet Gateway. Create EC2 Instance. Resource block: Create Elastic IP."},
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
    if not os.path.exists("data/prompts"):
        print("create prompts folder")
        os.makedirs("data/prompts")

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
    
    # check if tfsec executed without errors
    try:
        tfSecOutput = json.loads(result.stdout.decode("utf-8"))
    except:
        tfSecOutput = "error"

    return tfSecOutput

# saves the final code and data list
def finish(code, data, attempt, id):
    f = open(f"data/prompts/prompt_{id}_final_{attempt}.tf", "w+")
    f.write(code)
    f.close()

    f = open(f"data/prompts/prompt_{id}_final_{attempt}.json", "w+")
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
            f =  open(f"tmp/chatgpt.tf", "r")
            code = f.read()
            f.close()

            # append a new object that shows that chatgpt stopped generating code
            data.append({
            "prompt": str(prompt),
            "code": "no code from chatgpt",
            "tfsec": "",
            "number_of_issues": ""
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

            # save data inbetween attempts in case the program crashes
            f = open(f"data/prompts/prompt_{id}_try_{attempt}.json", "w+")
            f.write(json.dumps(data))
            f.close()
    
    if not stopped:
        f = open(f"data/prompts/prompt_{id}_final_{attempt}.tf", "w+")
        f.write(code)
        f.close()


debug = True
bot = ChatGPT()

response = bot.ask("Hello")
if not (response == 'Your ChatGPT session is not usable.\n* Run this program with the `install` parameter and log in to ChatGPT.\n* If you think you are already logged in, try running the `session` command.'):
    initFolders()

    for p in prompts:
        computePrompt(p)
else:
    print("ChatGPT is not working")