#!/bin/bash

menu(){
    echo " ______________________________________________________ "
    echo "|1- Contar arquivos da pasta                           |"
    echo "|2- Tornar arquivo executável                          |"
    echo "|3- Copiar arquivo                                     |"
    echo "|4- Tirar permissão de \"outros\"                        |"
    echo "|5- Dar permissão para \"grupo\" de R.W. (Read e Write)  |"
    echo "|6- Listar arquivos de uma pasta                       |"
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

copiarArquivo(){
    echo "Insira o caminho do arquivo a ser copiado:"
    read caminho

    if [ -e $caminho ]; then
        echo "Agora, insira o diretório para onde a cópia deve ser feita:"
        read caminhoCopia

        if [ -d $caminhoCopia ]; then
            cp $caminho $caminhoCopia
            ls -lap $caminhoCopia
        else
            echo "Insira um diretório válido"
        fi        
    else
        echo "O arquivo não existe"
    fi

    menu
}

tirarPermissoesOutros(){
    echo "O arquivo do qual você inserir o caminho a seguir não terá permissão nenhuma dada a outros:"
    read caminho
    chmod o-rwx $caminho
    echo "Veja, a seguir, se deu certo."
    listar
    menu
}

darPermissoesRWGrupo(){
    echo "O arquivo do qual você inserir o caminho a seguir terá permissões de leitura e escrita pelo grupo:"
    read caminho
    chmod g+rw $caminho
    echo "Veja, a seguir, se deu certo."
    listar
    menu
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