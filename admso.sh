#!/bin/bash

menu(){
    clear

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
    echo "Existe(m) $arquivos arquivo(s) no caminho $caminho"
    sleep
    menu
}

tornarX(){
    echo "Indique o caminho do script a tornar executável (todos terão permissão para executar):"
    read caminho
    chmod +x $caminho
    echo "Permissões alteradas. Cheque:"
    ls -lap $caminho
    echo "Sou um programa burro demais para detectar se deu certo. O arquivo ficou executável? (s/n)"
    read resposta

    case $resposta in 
        "s") echo "Beleza, obrigado." ;;
        "S") echo "Beleza, obrigado." ;;
        "n") echo "Sinto muito. Verifique o caminho e o erro apresentado pelo comando e tente novamente." ;;
        "N") echo "Sinto muito. Verifique o caminho e o erro apresentado pelo comando e tente novamente." ;;
        *) echo "Não entendi o que você disse, mas beleza, boto fé." ;;
    esac

    sleep 5
    menu
}

copiarArquivo(){
    echo "Insira o caminho do arquivo a ser copiado:"
    read caminho
    echo "Agora, insira o caminho para onde a cópia deve ser feita:"
    read caminhoCopia
    cp $caminho $caminhoCopia
    ls -lap $caminhoCopia
    sleep 5
    menu
}

tirarPermissoesOutros(){
    echo "O arquivo do qual você inserir o caminho a seguir não terá permissão nenhuma dada a outros:"
    read caminho
    chmod o-rwx $caminho
    echo "Veja, a seguir, se deu certo."
    listar
    sleep 5
    menu
}

darPermissoesRWGrupo(){
    echo "O arquivo do qual você inserir o caminho a seguir terá permissões de leitura e escrita pelo grupo:"
    read caminho
    chmod g+rw $caminho
    echo "Veja, a seguir, se deu certo."
    listar
    sleep 5
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