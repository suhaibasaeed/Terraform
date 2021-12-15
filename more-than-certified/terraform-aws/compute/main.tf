# Compute/main.tf

# ami data source
data "aws_ami" "server_ami" {
    # Pull most recent version of AMI
    most_recent = true
    owners = ["099720109477"]
    
    filter {
        # Filter by name of AMI
        name = "name"
        # Always get latest version with *
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
    
}