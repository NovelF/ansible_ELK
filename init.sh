#!/bin/bash

# Función para copiar la clave SSH al usuario remoto
copy_ssh_key() {
    sudo apt install sshpass -y > /dev/null
    # Solicitar la dirección IP del equipo remoto
    read -p "Introduce la dirección IP del equipo remoto: " remote_ip

    # Solicitar el nombre de usuario
    read -p "Introduce el nombre de usuario en el equipo remoto: " remote_user

    # Solicitar la contraseña del usuario
    read -s -p "Introduce la contraseña del usuario $remote_user@$remote_ip: " remote_password
    echo

    # Generar un nombre único para la clave SSH
    ssh_key_name="id_rsa_${remote_user}_${remote_ip}"


    # Copiar la clave pública al usuario del equipo remoto
    echo "Copiando clave SSH al usuario $remote_user del equipo remoto $remote_ip..."
    sshpass -p "$remote_password" ssh-copy-id "$remote_user@$remote_ip" > /dev/null


    if [ $? -eq 0 ]; then
        echo "Clave SSH copiada exitosamente al usuario $remote_user del equipo remoto $remote_ip."
    else
        echo "Ha ocurrido un error al copiar la clave SSH al usuario $remote_user del equipo remoto $remote_ip."
        echo "Asegúrate de que la contraseña sea correcta y que el usuario permita la conexión por SSH."
    fi
}

# Función para ejecutar el playbook con sudo
run_playbook() {
    sudo ansible-playbook playbook/install_kibana_elastic.yml  -i inventory/hosts2
    sudo ansible-playbook playbook/install_suricata.yml  -i inventory/hosts
}

# Menú principal
while true; do
    echo "### Menú ###"
    echo "1. Copiar clave SSH al usuario del equipo remoto"
    echo "2. Ejecutar playbook"
    echo "3. Salir"

    read -p "Elige una opción: " option

    case $option in
        1)
            copy_ssh_key
            ;;
        2)
            run_playbook
            ;;
        3)
            echo "Saliendo del programa."
            exit
            ;;
        *)
            echo "Opción no válida. Por favor, elige una opción del menú."
            ;;
    esac
done
