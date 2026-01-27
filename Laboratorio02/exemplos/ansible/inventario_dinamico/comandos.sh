ansible-inventory -i demo.aws_ec2.yml --graph
ansible-playbook -i demo.aws_ec2.yml playbook.yml --check
ansible-playbook -i demo.aws_ec2.yml playbook.yml 
