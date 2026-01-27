# Verificar a conexão com os hosts do inventário dinâmico
ansible-inventory -i aws_ec2.yml --graph
# Executar o playbook em modo de verificação (check mode)
ansible-playbook -i aws_ec2.yml playbook.yml --check
# Executar o playbook normalmente
ansible-playbook -i aws_ec2.yml playbook.yml 
