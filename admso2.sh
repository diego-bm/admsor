#!/bin/bash

menu(){
    echo " ________________________________ "
    echo "|1- Contar arquivos da pasta     |"
    echo "|2- Tornar arquivo executável    |"
    echo "|3- Tirar permissão de \"outros\"  |"
    echo "|4- Copiar arquivo               |"
    echo "|5- Trocar o nome de um arquivo  |"
    echo "|6- Criar um usuário             |"
    echo "|7- Listar arquivos de uma pasta |"
    echo "|0- Sair                         |"
    echo "|________________________________|"

    read opcao
    case $opcao in
        0) exit ;;
        1) contarArquivos ;;
        2) tornarX ;;
        3) tirarPermissoesOutros ;;
        4) copiarArquivo ;;
        5) renomear ;;
        6) criarUsuario ;;
        7) listarArquivos ;;
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
        fi
    else
        echo "O arquivo ou diretório não existe"
    fi    

    menu
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
        echo "O arquivo não existe"
    fi

    menu
}

copiarArquivo(){
    echo "Insira o caminho do arquivo a ser copiado:"
    read caminho

    if [ -e $caminho ]; then
        echo "Agora, insira o diretório para onde a cópia deve ser feita:"
        read caminhoCopia

        if [ -d $caminhoCopia ]; then
            cp $caminho $caminhoCopia
            if [ -e $caminhoCopia ]; then 
                echo "Copiado com sucesso!"
                ls -lap $caminhoCopia
            else
                echo "ERRO: o arquivo não foi copiado."
                copiarArquivo
            fi
        else
            echo "Insira um diretório válido"
            copiarArquivo
        fi        
    else
        echo "O arquivo não existe"
        copiarArquivo
    fi

    menu
}

renomear(){
    echo "Insira o caminho do DIRETÓRIO onde está o arquivo:"
    read caminho

    if [ -d $caminho ]; then
        echo "Insira o nome do arquivo:"
        read arquivo
        arquivosPresentes=$(ls $caminho)

        if [[ arquivosPresentes == *"$arquivo"* ]]; then
            echo "Insira o novo nome desse arquivo:"
            read novoNome
            if [[ arquivosPresentes == *"$novoNome"* ]]; then
                echo "Você vai substituir um arquivo com o mesmo nome por esse que está renomeando. Deseja continuar? (s/n)"
                read opcao
                case $opcao in
                    "s") 
                        mv $caminho/$arquivo $caminho/$novoNome ;;
                    "n") 
                        echo "Ok, voltando ao menu..." ;
                        menu ;;
                    *) 
                        echo "Opção inválida, voltando ao menu." ;
                        menu ;;
                esac
            else
                mv $caminho/$arquivo $caminho/$novoNome
            fi
        else
            echo "ERRO: o arquivo especificado não existe nesse diretório."
        fi
    else
        echo "ERRO: o caminho não especifica um diretório."
    fi
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

listar(){
    echo "Listando..."
    ls -lap $caminho
}

listarArquivos(){
    echo "Insira o caminho a ser listado:"
    read caminho
    listar
}

menu