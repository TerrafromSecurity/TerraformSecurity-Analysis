#in answer muss die markdown response von ChatGPT
answer = "Certainly! Here is an example Terraform script that deploys an AWS EC2 instance:```\n# Configure the AWS provider\nprovider \"aws\" {\n  access_key = \"<ACCESS_KEY>\"\n  secret_key = \"<SECRET_KEY>\"\n  region     = \"<REGION>\"\n}\n\n# Create the EC2 instance\nresource \"aws_instance\" \"example\" {\n  ami           = \"<AMI_ID>\"\n  instance_type = \"t2.micro\"\n\n  tags = {\n    Name = \"Example EC2 instance\"\n  }\n}\n```\n\nThis script does the following:\n\n```\nprint(\"Hello World!\")\n```\n\n1. Configures the AWS provider using the provided access key, secret key, and region.\n2. Creates an EC2 instance using the specified AMI ID and instance type. The instance is also given a Name tag.\n\nTo use this script, you will need to replace the placeholders with your own values. The `<ACCESS_KEY>` and `<SECRET_KEY>` placeholders should be replaced with your AWS access key and secret key, respectively. The `<REGION>` placeholder should be replaced with the desired region code (e.g. \"us-east-1\"). The `<AMI_ID>` placeholder should be replaced with the ID of the AMI that you want to use to launch ```the instance.\n\nI hope this helps! Let me know if you have any questions.`"

startOfCodeBlock = answer.find("```") + 3

c = answer[startOfCodeBlock]

codeBlocks = []
codeBlock = ""

while True:
    if c != '`':
        codeBlock += c
        startOfCodeBlock += 1
        if startOfCodeBlock >= len(answer):  #Abbruchbedingung falls eine ungerade Anzahl an "```" Tokens im input sind
            break
        c = answer[startOfCodeBlock]
    else:
        if answer[startOfCodeBlock:startOfCodeBlock+3] == "```": #Wenn wir bei einem '`' char angekommen sind überprüfen wir ob 3 in Folge kommen
            codeBlocks.append(codeBlock)
            if answer[startOfCodeBlock + 3:].find("```") == -1: #Abbruchbedingung wenn keine "```" mehr zu finden ist 
                break
            else:  #Variablen passend setzen um nächsten Codeblock zu extrahieren
                startOfCodeBlock += 6 + answer[startOfCodeBlock + 3:].find("```")
                codeBlock = ""
                c = answer[startOfCodeBlock]
        else:  #Ein '`' char im Code (normal fortfahren)
            codeBlock += c
            startOfCodeBlock += 1
            if startOfCodeBlock >= len(answer):  #Abbruchbedingung falls eine ungerade Anzahl an "```" Tokens im input sind und der Input mit einem '`' char endet
                break
            c = answer[startOfCodeBlock]

for index, code in enumerate(codeBlocks):
    print("Code Block " + str(index) + ":")
    print(code)