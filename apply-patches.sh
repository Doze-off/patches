#!/bin/bash

set -e

mkdir -p logs

# Redirecionar tudo (stdout + stderr) para o log e console ao mesmo tempo
exec > >(tee -a logs/log.txt) 2>&1

# Verifica se o parâmetro foi fornecido
if [ -z "$1" ]; then
    echo "Uso: $0 <diretório-fonte>"
    echo "Exemplo: $0 ~/crDroid"
    exit 1
fi

source="$(readlink -f -- "$1")"
trebledroid="$source/patches/trebledroid"
personal="$source/patches/personal"

# Verifica se os diretórios de patches existem
if [ ! -d "$trebledroid" ] || [ ! -d "$personal" ]; then
    echo "Erro: Diretórios de patches não encontrados em $source/patches/"
    exit 1
fi

printf "\n ### APPLYING TREBLEDROID PATCHES ###\n"
sleep 1.0
for path in $(cd "$trebledroid" && echo *); do
    tree="$(tr _ / <<<"$path" | sed -e 's;platform/;;g')"
    printf "\n| $path ###\n"
    [ "$tree" == build ] && tree=build/make
    [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
    [ "$tree" == treble/app ] && tree=treble_app
    
    if [ ! -d "$tree" ]; then
        printf "### DIRETÓRIO NÃO ENCONTRADO: $tree - PULANDO ###\n"
        continue
    fi
    
    pushd "$tree" >/dev/null

    for patch in "$trebledroid/$path"/*.patch; do
        [ -f "$patch" ] || continue
        
        # Check if patch is already applied
        if patch -f -p1 --dry-run -R < "$patch" >/dev/null 2>&1; then
            printf "### JÁ APLICADO: $patch \n"
            continue
        fi

        if git apply --check "$patch" 2>/dev/null; then
            git am "$patch"
        elif patch -f -p1 --dry-run < "$patch" >/dev/null 2>&1; then
            git am "$patch" || true
            patch -f -p1 < "$patch"
            git add -u
            git am --continue
        else
            printf "### FALHA AO APLICAR: $patch \n"
        fi
    done

    popd >/dev/null
done

printf "\n### APPLYING PERSONAL PATCHES ###\n"
sleep 1.0
for path_personal in $(cd "$personal" && echo *); do
    tree="$(tr _ / <<<"$path_personal" | sed -e 's;platform/;;g')"
    printf "\n| $path_personal ###\n"
    [ "$tree" == build ] && tree=build/make
    [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
    [ "$tree" == treble/app ] && tree=treble_app
    [ "$tree" == vendor/partner/gms ] && tree=vendor/partner_gms
    
    if [ ! -d "$tree" ]; then
        printf "### DIRETÓRIO NÃO ENCONTRADO: $tree - PULANDO ###\n"
        continue
    fi
    
    pushd "$tree" >/dev/null

    for patch in "$personal/$path_personal"/*.patch; do
        [ -f "$patch" ] || continue
        
        if patch -f -p1 --dry-run -R < "$patch" >/dev/null 2>&1; then
            printf "### JÁ APLICADO: $patch \n"
            continue
        fi

        if git apply --check "$patch" 2>/dev/null; then
            git am "$patch"
        elif patch -f -p1 --dry-run < "$patch" >/dev/null 2>&1; then
            git am "$patch" || true
            patch -f -p1 < "$patch"
            git add -u
            git am --continue
        else
            printf "### FALHA AO APLICAR: $patch \n"
        fi
    done

    popd >/dev/null
done