import subprocess
import io
import pypandoc
import panflute
from chatgpt_wrapper import ChatGPT
import json
import os
from pypandoc.pandoc_download import download_pandoc
# download_pandoc()

prompts = [
    {"id": 1, "prompt": "Can you deploy an AWS EC2 instance."},
    # {"id": 2, "prompt": "Can you create a VPC gateway instance with elastic IP on AWS?"},
    # {"id": 3, "prompt": "Can you create a S3 Bucket on AWS?"},
    # {"id": 4, "prompt": "Can you provision a t2.micro instance on AWS?"},
    # {"id": 5, "prompt": "Can you deploy a web server with a public IP on AWS?"},
    # {"id": 6, "prompt": "Can you change the AMI of an AWS EC2 instance to Ubuntu 16.04?"},
]

settingsPrompts = [
    "Can you create terraform configuration code in the following?",
    "Don't forget the starting terraform block.",
    "Only print out a single code block per response.",
    "Fill any placeholders with dummy values.",
    "The code should be generated based on the following description."
]


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


debug = True

bot = ChatGPT()
settings = " ".join(settingsPrompts)

# generate tmp folder if it does not exist
if not os.path.exists("tmp"):
    print("create tmp folder")
    os.makedirs("tmp")

# generate prompts and data folder if they do not exist
if not os.path.exists("data/prompts"):
    print("create prompts folder")
    os.makedirs("data/prompts")

# i = 0
for p in prompts:
    id, prompt = p.values()
    data = [] # stores all the generated code blocks
    # prompt = input("Please type in a description what your Terraform script should do or 'exit' if you want to quit:\n>")
    # if prompt == "exit":
    #     break
    # solved = False

    # save the number of the minimum achieved vulnerabilites and which try achieved this minimum
    minVulnerabilities = 10 ** 10
    tryMinVulnerabilites = 0

    # give chatgpt at most 10 retries to ix all problems
    # (0) for the first question to chatgpt we add some setting prompts
    prompt = settings + "\n" + prompt
    for tries in range(5):
        previousIssues = []
        solvedIssues = []
        # while True:
        #     newIssues = []
        #     data = []
        #     if debug:
        #         print(f"Prompt {i + 1}: {prompt}")

        # (1) Get first response and save to file
        print(f"### PROMPT: {prompt}")
        print("Waiting for response ... ")
        response = bot.ask(prompt)
        print("ChatGPT: \n", response)
        f = open("tmp/chatgpt.md", "w+")
        f.write(response)
        f.close()

        if debug:
            print(f"write response in tf file")

        # (2) Extract code from markdown file and write to terraform file
        code = "\n".join(extract_code(response))
        if os.path.exists("tmp/chatgpt.tf"):
            os.remove("tmp/chatgpt.tf")
        f = open(f"tmp/chatgpt.tf", "w+")
        f.write(code)
        f.close()

        if debug:
            print(f"run tfsec")

        # (3) run tfsec on the terraform file
        result = subprocess.run(["tfsec", f"tmp/", "-f", "json"], capture_output=True)

        # (4) extract tfsec descriptions from the csv output
        tfSecOutput = json.loads(result.stdout.decode("utf-8"))


        # (5) check if tfsec found any issues
        number_of_issues = len(tfSecOutput["results"])
        print(f"Detected {number_of_issues} issues")
        data.append({
            "iteration": str(tries + 1),
            "prompt": str(prompt),
            "response": str(response),
            "tfsec": str(result.stdout.decode("utf-8")),
            "number_of_issues": str(number_of_issues)
        })
        if number_of_issues == 0:
            # (5a) Done, write to file
            print("All issues have been solved")
            # save final TF file
            f = open(f"data/prompts/prompt_{id}_final_{tries}.tf", "w+")
            f.write(code)
            f.close()
            # save final data
            f = open(f"data/prompts/prompt_{id}_final_{tries}.json", "w+")
            f.write(json.dumps(data))
            f.close()
            minVulnerabilities = 0
            tryMinVulnerabilites = tries
            solved = True
            break
        else:
            # (5b) detected issues, build new prompt to make chatgpt solve them
            # this is the new prompt
            # loop is executed with the updated prompt
            prompt = "I detect the following security vulnerabilities, can you fix them?\n"

            # add the json object for each vulnerability to to prompt
            newIssues = []
            for i, issue in enumerate(tfSecOutput["results"]):
                prompt = prompt + "Vulnerablitity " + str(i) + ":\n"
                prompt = prompt + str(issue) + "\n"
                newIssues.append(tfSecOutput["results"][i]["rule_id"])


            # (5b) save all the data of this iteration to a json file
            f = open(f"data/prompts/prompt_{id}_try_{tries}.json", "w+")
            f.write(json.dumps(data))
            f.close()



        # check if the one of the issues that were already solved got reintroduced to the tf script
        # for issues in newIssues:
        #     if solvedIssues.__contains__(issue):
        #         print("Previously solved issue occured again.")
        #         f = open(f"data/prompts/prompt_{id}_CodeOfTry_{tries}.tf", "w+")
        #         f.write(code)
        #         f.close()
        #         break
        #
        # # check if one of the previous vulnerabilities was fixed and add them to the solved issues
        # solvedOneIssue = False
        # for issue in previousIssues:
        #     if not newIssues.__contains__(issue):
        #         solvedOneIssue = True
        #         solvedIssues.append(issue)
        #
        # # if there was no security issue fixed from the previous cancel this try
        # if not solvedOneIssue:
        #     f = open(f"data/prompts/prompt_{id}_CodeOfTry_{tries}.tf", "w+")
        #     f.write(code)
        #     f.close()
        #     break
        #
        # print(f"Number of security issues: {len(newIssues)}")
        #
        # iteration += 1

        # end of while True

        # if we solved all vulerabilities we can stop trying to generate code
        # if solved:
        #     break

    # end of tries for loop

    # if solved is True chatgpt managed to generate a save terraform file
    # if solved:
    #     f = open("tmp/chatgpt.tf", "r")
    #     lines = f.readlines()
    #     print("This is the secure solution chatgpt generated for you.\n\n")
    #     for line in lines:
    #         print(line)
    #
    # # if solved is False chatgpt couln't resolve all vulnerabilities
    # else:
    #     f = open(f"data/prompts/prompt_{i}_CodeOfTry_{tryMinVulnerabilites}.tf")
    #     lines = f.readlines()
    #     print(f"This is the best solution chatgpt could generate for you. It still has {minVulnerabilities} Vulnerabilities left.")
    #     for line in lines:
    #         print(line)
    #
    # i += 1
