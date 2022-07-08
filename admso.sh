#!/bin/bash
#TODO: FUNCIONALIZAR REPETÊNCIAS
#TODO: USAR /DEV/NULL PARA DEIXAR O PROGRAMA MAIS USER-FRIENDLY
#TODO: ADICIONAR MAIS VALIDAÇÕES NA FUNÇÃO 13

menu(){
    echo " ______________________________________________________ "
    echo "|1- Contar arquivos da pasta                           |"
    echo "|2- Tornar arquivo executável                          |"
    echo "|3- Copiar arquivo                                     |"
    echo "|4- Tirar permissão de \"outros\"                        |"
    echo "|5- Dar permissão para \"grupo\" de R.W. (Read e Write)  |"
    echo "|6- Listar arquivos de uma pasta                       |"
    echo "|7- Trocar o nome de um arquivo                        |"
    echo "|8- Criar um usuário                                   |"
    echo "|9- Apagar um usuário                                  |"
    echo "|10- Criar um grupo                                    |"
    echo "|11- Apagar um grupo                                   |"
    echo "|12- Mostrar meu IP                                    |"
    echo "|13- Compartilhar uma pasta em rede através do Samba   |"
    echo "|0- Sair                                               |"
    echo "|______________________________________________________|"

    read opcao
    case $opcao in
        0) exit ;;
        1) contarArquivos ;;
        2) tornarX ;;
        3) copiarArquivo ;;
        4) tirarPermissoesOutros ;;
        5) darPermissoesRWGrupo ;;
        6) listarArquivos ;;
        7) renomear ;;
        8) criarUsuario ;;
        9) apagarUsuario ;;
        10) criarGrupo ;;
        11) apagarGrupo ;;
        12) mostrarIP ;;
        13) compartilharSamba ;;
        *) echo "Opção inválida." ;;
    esac
}

contarArquivos(){
    echo "Indique o caminho da pasta a se contar os arquivos presentes:"
    read caminho
    arquivos=`ls -l $caminho | wc -l`
    ((arquivos=$arquivos-1))

    if [ $arquivos -gt 0 ]; then
        if [ $arquivos -eq 1 ]; then
            echo "Existe $arquivos arquivo no caminho $caminho"
        else
            echo "Existem $arquivos arquivos no caminho $caminho"
        fi
    else
        echo "Não há nenhum arquivo no caminho especificado."
    fi

    menu
}

tornarX(){
    echo "Indique o caminho do script a tornar executável (todos terão permissão para executar):"
    read caminho

    if [ -e caminho ]; then
        chmod +x $caminho
        if [ -x $caminho ]; then
            echo "O arquivo teve a permissão concedida com sucesso."
            ls -lap $caminho
        else
            echo "ERRO: o arquivo não teve a permissão concedida."
            ls -lap $caminho
            echo "Tente novamente."
            tornarX
        fi
    else
        echo "O arquivo ou diretório não existe. Tente novamente."
        tornarX
    fi    

    menu
}

copiarArquivo(){
    copiarArquivoCheck1         

    if [ -e $caminhoCopia ]; then 
        echo "Copiado com sucesso!"
        ls -lap $caminhoCopia
    else
        echo "ERRO: o arquivo não foi copiado. Verifique o erro e tente novamente."
        copiarArquivo
    fi

    menu
}

copiarArquivoCheck1(){
    echo "Insira o caminho do arquivo a ser copiado:"
    read caminho

    if [ -e $caminho ]; then
        copiarArquivoCheck2
    else
        echo "O arquivo não existe, tente novamente."
        copiarArquivoCheck1
    fi
}

copiarArquivoCheck2(){
    echo "Agora, insira o diretório para onde a cópia deve ser feita:"
    read caminhoCopia

    if [ -d $caminhoCopia ]; then
        cp $caminho $caminhoCopia
    else
        echo "Insira um diretório válido"
        copiarArquivoCheck2
    fi 
}

tirarPermissoesOutros(){
    echo "O arquivo do qual você inserir o caminho a seguir não terá permissão nenhuma dada a outros:"
    read caminho

    if [ -e $caminho ]; then
        chmod o-rwx $caminho
        permissao=$(stat -c "%A" $caminho)
        if [[ $permissao == *"---" ]]; then
            echo "Permissão alterada com sucesso"
            ls -lap $caminho
        else
            echo "ERRO: a permissão não foi alterada."
            ls -lap $caminho
            tirarPermissoesOutros
        fi
    else
        echo "O arquivo não existe. Tente novamente."
        tirarPermissoesOutros
    fi

    menu
}

darPermissoesRWGrupo(){
    echo "O arquivo do qual você inserir o caminho a seguir terá permissões de leitura e escrita pelo grupo:"
    read caminho
    if [ -e $caminho ]; then
        chmod g+rw $caminho
        permissao=$(stat -c "%A" $caminho)
        #Parameter Expansion (Expansão de Parâmetros)
        permissao=${permissao:4:2}
        if [[ $permissao == "rw" ]]; then
            echo "Permissão alterada com sucesso"
            ls -lap $caminho
        else
            echo "ERRO: a permissão não foi alterada."
            ls -lap $caminho
            darPermissoesRWGrupo
        fi
    else
        echo "O arquivo não existe. Tente novamente."
        darPermissoesRWGrupo
    fi

    menu
}

listar(){
    echo "Listando..."
    ls -lap $caminho
}

listarArquivos(){
    echo "Insira o caminho a ser listado:"
    read caminho
    if [ -d $caminho ]; then
        listar
    else
        echo "Não é um diretório válido ou existente. Tente novamente."
        listarArquivos
    fi
}

renomear(){
    echo "Insira o caminho do DIRETÓRIO onde está o arquivo:"
    read caminho

    if [ -d $caminho ]; then
        renomearCheck1
    else
        echo "ERRO: o caminho não especifica um diretório. Tente novamente."
        renomear
    fi
}

renomearCheck1(){
    echo "Insira o nome do arquivo:"
    read arquivo
    arquivosPresentes=$(ls $caminho)

    if [[ arquivosPresentes == *"$arquivo"* ]]; then
        renomearCheck2
    else
        echo "ERRO: o arquivo especificado não existe nesse diretório."
    fi
}

renomearCheck2(){
    echo "Insira o novo nome desse arquivo:"
    read novoNome
    if [[ arquivosPresentes == *"$novoNome"* ]]; then
        renomearCheck3
    else
        mv $caminho/$arquivo $caminho/$novoNome
    fi
}

renomearCheck3(){
    echo "Você vai substituir um arquivo com o mesmo nome por esse que está renomeando. Deseja continuar? (s/n)"
    renomearCheck4
}

renomearCheck4(){
    read opcao
    case $opcao in
        "s") 
            mv $caminho/$arquivo $caminho/$novoNome ;;
        "n") 
            echo "Então..."
            renomearCheck2 ;;
        *) 
            echo "Opção inválida. Responda de novo." ;
            renomearCheck4 ;;
    esac
}

criarUsuario(){
    echo "Insira o nome do usuário a ser criado, o Linux cuidará do resto para você (em inglês):"
    read nomeUsuario
    if [[ nomeUsuario == "" ]]; then
        echo "ERRO: insira um nome para o usuário."
        criarUsuario
    else
        sudo adduser $nomeUsuario
    fi
}

apagarUsuario(){
    listarUsuarios
    echo ""
    echo "Recomendamos apenas deletar usuários que vêm abaixo do nome do seu."
    echo "Escreva abaixo o nome do usuário a ser deletado:"
    read usuario

    sudo userdel $usuario
    listarUsuarios
}

criarGrupo(){
    echo "Qual o nome do grupo que quer criar?"
    read grupo
    sudo groupadd $grupo
    listarGrupos
}

apagarGrupo(){
    listarGrupos

    echo "Insira o nome do grupo a ser deletado. "
    echo "Recomendamos apenas deletar grupos que vêm abaixo do nome do seu."
    read grupo
    sudo groupdel $grupo

    listarGrupos
}

mostrarIP(){
    echo "Trabalhando..."
    ip=`curl ifconfig.me`
    echo "Seu ip é $ip"
}

listarUsuarios(){
    echo "Os usuários dessa maquina são:"
    echo "____________________________"
    cut -d: -f1 /etc/passwd
    echo "____________________________"
}

listarGrupos(){
    echo "Os grupos dessa maquina são:"
    echo "____________________________"
    cat /etc/group | cut -d: -f1
    echo "____________________________"
}

compartilharSamba(){
    echo "Qual o nome do compartilhamento?"
    read compartilhamento

    echo "E do usuário?"
    read usuarioCompartilhamento

    sudo cut -d: -f1 /etc/passwd | grep "$usuarioCompartilhamento" &> /dev/null

    if [ ! $? -eq 0 ]; then
        clear
        echo "Usuário não existe. Criando..."
        sudo adduser $usuarioCompartilhamento
    fi

    echo "Insira a senha do Samba."
    sudo smbpasswd -a $usuarioCompartilhamento

    if [ -d /home/$usuarioCompartilhamento/$compartilhamento ]; then
        echo "Diretório já preparado!"
    else
        echo "Diretório não existe. Criando..."
        sudo mkdir /home/$usuarioCompartilhamento/$compartilhamento
        if [ -d /home/$usuarioCompartilhamento/$compartilhamento ]; then
            echo "Diretório criado!"
        else
            echo "ERRO AO CRIAR O DIRETÓRIO!"
        fi
        
        echo "Aplicando permissões ao usuário..."
        sudo chmod 777 /home/$usuarioCompartilhamento/$compartilhamento
    fi

    echo "Gerando arquivo de configurações globais..."
    echo "[global]" > smb.temp
	echo "workgroup = admsor" >> smb.temp
	echo "netbios name = pcdiego" >> smb.temp
   	echo "security = user" >> smb.temp

    echo "Gerando arquivo de compartilhamento do usuário..."
    echo "[$compartilhamento]" > $compartilhamento.comp
    echo "comment = arquivos do(a) $usuarioCompartilhamento" >> $compartilhamento.comp
    echo "path = /home/$usuarioCompartilhamento/$compartilhamento" >> $compartilhamento.comp 
    echo "browseable = yes" >> $compartilhamento.comp
    echo "read only = no" >> $compartilhamento.comp
    echo "guest ok = yes" >> $compartilhamento.comp
    echo "valid users = $usuarioCompartilhamento" >> $compartilhamento.comp

    echo "Concatenando..."
    cat smb.temp > smb.conf
	cat *.comp >> smb.conf
	sudo cp smb.conf /etc/samba/smb.conf
    sudo chown root.root /etc/samba/smb.conf

    echo "Reiniciando o serviço do Samba..."
    systemctl restart smbd

    echo "Terminado!"
    menu
}

menu