#!/bin/bash
#TODO: FUNCIONALIZAR REPETÊNCIAS
#TODO: USAR /DEV/NULL PARA DEIXAR O PROGRAMA MAIS USER-FRIENDLY
#TODO: ADICIONAR MAIS VALIDAÇÕES NA FUNÇÃO 13
#TODO: SEPARAR PROGRAMA EM PROGRAMAS MENORES (SUB-PROGRAMAS)
#DESISTIDO: DELETAR COMPARTILHAMENTO SAMBA

Menu(){
    clear

    echo " _______________________________________________________________ "
    echo "|1- Contar arquivos da pasta                                    |"
    echo "|2- Tornar arquivo executável                                   |"
    echo "|3- Copiar arquivo                                              |"
    echo "|4- Tirar permissão de \"outros\"                                 |"
    echo "|5- Dar permissão para \"grupo\" de R.W. (Read e Write)           |"
    echo "|6- Listar arquivos de uma pasta                                |"
    echo "|7- Trocar o nome de um arquivo                                 |"
    echo "|8- Criar um usuário                                            |"
    echo "|9- Apagar um usuário                                           |"
    echo "|10- Criar um grupo                                             |"
    echo "|11- Apagar um grupo                                            |"
    echo "|12- Mostrar meu IP                                             |"
    echo "|13- [SAMBA] Compartilhar uma pasta em rede                     |"
    echo "|14- [SAMBA] Mostrar compartilhamentos ativos                   |"
    echo "|15- [SAMBA] Testar parâmetros de configuração                  |"
    echo "|16- [SAMBA] Verificar instalação                               |"
    echo "|17- [SAMBA] Mostrar compartilhamentos ativos em um host remoto |"
    # echo "|18- [SAMBA] Deletar compartilhamento                           |"
    echo "|0- Sair                                                        |"
    echo "|_______________________________________________________________|"

    read opcao
    case $opcao in
        0) exit ;;
        1) ContarArquivos ;;
        2) TornarX ;;
        3) CopiarArquivo ;;
        4) TirarPermissoesOutros ;;
        5) DarPermissoesRWGrupo ;;
        6) ListarArquivos ;;
        7) Renomear ;;
        8) CriarUsuario ;;
        9) ApagarUsuario ;;
        10) CriarGrupo ;;
        11) ApagarGrupo ;;
        12) MostrarIP ;;
        13) CompartilharSamba ;;
        14) ListarCompartilhamentosSamba ;;
        15) TestarConfigSamba ;;
        16) VerificarSambaInstalado ;;
        17) ListarCompartilhamentosSambaRemoto ;;
        # 18) RemoverCompartilhamentoSamba ;;
        *) echo "Opção inválida." ;;
    esac
}

AperteEnter(){
    read -p "Aperte ENTER para continuar..."

    Menu
}

ContarArquivos(){
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

    AperteEnter
}

TornarX(){
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
            TornarX
        fi
    else
        echo "O arquivo ou diretório não existe. Tente novamente."
        TornarX
    fi    

    AperteEnter
}

CopiarArquivo(){
    CopiarArquivoCheck1         

    if [ -e $caminhoCopia ]; then 
        echo "Copiado com sucesso!"
        ls -lap $caminhoCopia
    else
        echo "ERRO: o arquivo não foi copiado. Verifique o erro e tente novamente."
        CopiarArquivo
    fi

    AperteEnter
}

CopiarArquivoCheck1(){
    echo "Insira o caminho do arquivo a ser copiado:"
    read caminho

    if [ -e $caminho ]; then
        CopiarArquivoCheck2
    else
        echo "O arquivo não existe, tente novamente."
        CopiarArquivoCheck1
    fi
}

CopiarArquivoCheck2(){
    echo "Agora, insira o diretório para onde a cópia deve ser feita:"
    read caminhoCopia

    if [ -d $caminhoCopia ]; then
        cp $caminho $caminhoCopia
    else
        echo "Insira um diretório válido"
        CopiarArquivoCheck2
    fi 
}

TirarPermissoesOutros(){
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
            TirarPermissoesOutros
        fi
    else
        echo "O arquivo não existe. Tente novamente."
        TirarPermissoesOutros
    fi

    AperteEnter
}

DarPermissoesRWGrupo(){
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
            DarPermissoesRWGrupo
        fi
    else
        echo "O arquivo não existe. Tente novamente."
        DarPermissoesRWGrupo
    fi

    AperteEnter
}

Listar(){
    echo "Listando..."
    ls -lap $caminho
}

ListarArquivos(){
    echo "Insira o caminho a ser listado:"
    read caminho
    if [ -d $caminho ]; then
        Listar
    else
        echo "Não é um diretório válido ou existente. Tente novamente."
        ListarArquivos
    fi
}

Renomear(){
    echo "Insira o caminho do DIRETÓRIO onde está o arquivo:"
    read caminho

    if [ -d $caminho ]; then
        RenomearCheck1
    else
        echo "ERRO: o caminho não especifica um diretório. Tente novamente."
        Renomear
    fi
}

RenomearCheck1(){
    echo "Insira o nome do arquivo:"
    read arquivo
    arquivosPresentes=$(ls $caminho)

    if [[ "$arquivosPresentes" == *"$arquivo"* ]]; then
        RenomearCheck2
    else
        echo "ERRO: o arquivo especificado não existe nesse diretório."
    fi
}

RenomearCheck2(){
    echo "Insira o novo nome desse arquivo:"
    read novoNome
    if [[ arquivosPresentes == *"$novoNome"* ]]; then
        RenomearCheck3
    else
        mv $caminho/$arquivo $caminho/$novoNome
    fi
}

RenomearCheck3(){
    echo "Você vai substituir um arquivo com o mesmo nome por esse que está renomeando. Deseja continuar? (s/n)"
    RenomearCheck4
}

RenomearCheck4(){
    read opcao
    case $opcao in
        "s") 
            mv $caminho/$arquivo $caminho/$novoNome ;;
        "n") 
            echo "Então..."
            RenomearCheck2 ;;
        *) 
            echo "Opção inválida. Responda de novo." ;
            RenomearCheck4 ;;
    esac
}

CriarUsuario(){
    echo "Insira o nome do usuário a ser criado, o Linux cuidará do resto para você (em inglês):"
    read nomeUsuario
    if [[ nomeUsuario == "" ]]; then
        echo "ERRO: insira um nome para o usuário."
        CriarUsuario
    else
        sudo adduser $nomeUsuario
        CriarUsuarioCheckSamba
    fi
}

CriarUsuarioCheckSamba(){
    read -p "Deseja criar um usuário do Samba para esse novo usuário? (S/n) " opcao
    case $opcao in
        "s") 
            echo "Criando usuário do Samba..." ;
            CriarUsuarioSamba ;;
        "S") 
            echo "Criando usuário do Samba..." ;
            CriarUsuarioSamba ;;
        "n") 
            echo "Ok, retornando ao menu..." ;
            AperteEnter ;;
        "N") 
            echo "Ok, retornando ao menu..." ;
            AperteEnter ;;
        *) 
            echo "Opção inválida. Responda de novo." ;
            CriarUsuarioCheckSamba ;;
    esac
}

ApagarUsuario(){
    ListarUsuarios
    echo ""
    echo "Recomendamos apenas deletar usuários que vêm abaixo do nome do seu."
    echo "Escreva abaixo o nome do usuário a ser deletado:"
    read usuario

    sudo userdel $usuario
    ListarUsuarios
}

CriarGrupo(){
    echo "Qual o nome do grupo que quer criar?"
    read grupo
    sudo groupadd $grupo
    ListarGrupos
}

ApagarGrupo(){
    ListarGrupos

    echo "Insira o nome do grupo a ser deletado. "
    echo "Recomendamos apenas deletar grupos que vêm abaixo do nome do seu."
    read grupo
    sudo groupdel $grupo

    ListarGrupos
}

MostrarIP(){
    echo "Trabalhando..."
    ipInterno=`hostname -I`
    echo "Seu ip externo é: `curl -s ifconfig.me`"
    echo "Enquanto o seu IP interno e endereço MAC é, respectivamente: $ipInterno"

    AperteEnter
}

ListarUsuarios(){
    echo "Os usuários dessa maquina são:"
    echo "____________________________"
    cut -d: -f1 /etc/passwd
    echo "____________________________"
}

ListarGrupos(){
    echo "Os grupos dessa maquina são:"
    echo "____________________________"
    cat /etc/group | cut -d: -f1
    echo "____________________________"
}

CompartilharSamba(){
    InstalarSamba
    echo "Qual o nome do compartilhamento?"
    read compartilhamento

    if grep -q $compartilhamento "/etc/samba/smb.conf"; then
        echo "Esse compartilhamento já existe! Não é possivel criá-lo."
        AperteEnter
    fi

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
    AperteEnter
}

CriarUsuarioSamba(){
    InstalarSamba
    sudo smbpasswd -a $nomeUsuario
    AperteEnter
}

ListarCompartilhamentosSamba(){
    InstalarSamba
    echo "Você precisa logar com um usuário do Samba para conseguir ver as conexões ativas."
    read -p "Digite o usuário: " usuario

    usuarios=`cut -d: -f1 /etc/passwd`

    if [[ "$usuarios" == *"$usuario"* ]]; then
        smbclient -L 127.0.1.1 -U $usuario
    else
        read -p "O usuário \"$usuario\" não existe. Deseja criá-lo? (S/n) " opcao
        case $opcao in
            "s") 
                echo "Criando novo usuario..." ;
                CriarUsuario ;;
            "S") 
                echo "Criando novo usuario..." ;
                CriarUsuario ;;
            "n") 
                ListarCompartilhamentosSamba ;;
            "N") 
                ListarCompartilhamentosSamba ;;
            *) 
                echo "Opção inválida. Responda de novo." ;
                ListarCompartilhamentosSamba ;;
        esac
    fi
}

ListarCompartilhamentosSambaRemoto(){
    InstalarSamba
    echo "Digite o IP da conexão remota."
    read ip
    echo "Você precisa logar com um usuário do Samba da conexão inserida para conseguir ver as conexões ativas."
    read -p "Digite o usuário: " usuario

    smbclient -L $ip -U $usuario

    AperteEnter
}

InstalarSamba(){
    caminhoSamba=`whereis samba`
    caminhoSmbclient=`whereis smbclient`

    if [[ ! $caminhoSamba == *"/usr/sbin/samba"* ]]; then
        echo "ERRO: Samba não instalado. Instalando..."
        sudo apt-get install samba
        clear
    fi

    if [[ ! $caminhoSmbclient == *"/usr/bin/smbclient"* ]]; then
        echo "ERRO: SmbClient não instalado. Instalando..."
        sudo apt-get install smbclient
        clear
    fi
}

VerificarSambaInstalado(){
    caminhoSamba=`whereis samba`
    caminhoSmbclient=`whereis smbclient`

    if [[ ! $caminhoSamba == *"/usr/sbin/samba"* ]]; then
        read -p "Samba não instalado. Deseja instalá-lo? (S/n) " opcao
        case $opcao in
            "s") 
                echo "Instalando Samba..." ;
                sudo apt-get install samba ;
                clear ;
                VerificarSambaInstalado ;;
            "S") 
                echo "Instalando Samba..." ;
                sudo apt-get install samba ;
                clear ;
                VerificarSambaInstalado ;;
            "n") 
                echo "Ok, retornando ao menu..." ;
                AperteEnter ;;
            "N") 
                echo "Ok, retornando ao menu..." ;
                AperteEnter ;;
            *) 
                echo "Opção inválida. Responda de novo." ;
                VerificarSambaInstalado ;;
        esac
    else
        echo "Samba instalado!"
    fi

    if [[ ! $caminhoSmbclient == *"/usr/bin/smbclient"* ]]; then
        read -p "SmbClient não instalado. Deseja instalá-lo? (S/n) " opcao
        case $opcao in
            "s") 
                echo "Instalando SmbClient..." ;
                sudo apt-get install smbclient ;
                clear ;
                VerificarSambaInstalado ;;
            "S") 
                echo "Instalando SmbClient..." ;
                sudo apt-get install smbclient ;
                clear ;
                VerificarSambaInstalado ;;
            "n") 
                echo "Ok, retornando ao menu..." ;
                AperteEnter ;;
            "N") 
                echo "Ok, retornando ao menu..." ;
                AperteEnter ;;
            *) 
                echo "Opção inválida. Responda de novo." ;
                VerificarSambaInstalado ;;
        esac
    else
        echo "SmbClient instalado!"
    fi

    AperteEnter
}

TestarConfigSamba(){
    resultado=`tesparm`

    if [[ $resultado == *"Loaded services file OK."* ]]; then 
        echo "Configuração do Samba OK."
        echo "Tenha em mente que isso NÃO garante que a conexão funcionará."
    fi

    AperteEnter
}

# RemoverCompartilhamentoSamba(){
#     InstalarSamba

#     if [ -e "./smb.conf" ]; then
#         sudo mv ./smb.conf /dev/null
#     fi

#     if [ -e "./smb.temp" ]; then
#         sudo mv ./smb.temp /dev/null
#     fi


#     echo "Você precisa logar com um usuário do Samba para conseguir ver as conexões ativas."
#     read -p "Digite o usuário: " usuario

#     usuarios=`cut -d: -f1 /etc/passwd`

#     if [[ "$usuarios" == *"$usuario"* ]]; then
#         smbclient -L 127.0.1.1 -U $usuario
#     else
#         echo "O usuário \"$usuario\" não existe."
#         RemoverCompartilhamentoSamba
#     fi

#     echo "Qual dos compartilhamentos mostrados acima deseja deletar?"
#     read compartilhamento

#     contador=0

#     if grep -q $compartilhamento "/etc/samba/smb.conf"; then
#         while read p; do
#             if [[ $p == "[$compartilhamento]" ]]; then
#                 ((contador=$contador+1))
#                 rangeDeletarLinhaComeco=$contador

#                 while 
#                 [[ $p == *"["* ]] &&
#                 [[ ! $p == "[$compartilhamento]" ]]; do
#                     echo $p >> smb.temp
#                 done

#                 echo "$contador) $p"
#             # elif [ $contador = 1 ]; then
#             #     echo $p > smb.temp

#             #     ((contador=$contador+1))
#             #     echo "$contador) $p"
#             else
#                 echo $p >> smb.temp

#                 ((contador=$contador+1))
#                 echo "$contador) $p"
#             fi
#         done </home/diego/Área\ de\ trabalho/linha.txt

#         #Fazer o método de rodar as linhas, dessa vez tentando pegar só o pedaço do compartilhamento a ser removido
#         #Tentar fazer ele pegar da linha de inicio do range até o fim apenas, por exemplo
#         echo "Deletar da linha $rangeDeletarLinhaComeco a linha $rangeDeletarLinhaFim"


#         AperteEnter
#     fi
# }

Menu