#!/bin/bash

set -e

mkdir -p logs

# Redireciona stdout e stderr para o console e para logs/log.txt
# Redirect stdout and stderr to both console and logs/log.txt
exec > >(tee -a logs/log.txt) 2>&1

# Verifica se o diretório-fonte foi informado
# Check whether the source directory was provided
if [ -z "$1" ]; then
    echo "Uso / Usage: $0 <diretório-fonte / source-directory>"
    echo "Exemplo / Example: $0 ~/crDroid"
    exit 1
fi

source="$(readlink -f -- "$1")"

trebledroid="$source/patches/trebledroid"
rom="$source/patches/rom"
release_builds="$source/patches/release-builds"
personal_restless="$source/patches/personal-restless"
personal="$source/patches/personal"

# =========================================================
# APLICANDO PATCHES TREBLEDROID
# APPLYING TREBLEDROID PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES TREBLEDROID / APPLYING TREBLEDROID PATCHES ###\n"
sleep 1.0

for path in $(cd "$trebledroid" && echo *); do
    tree="$(tr _ / <<<"$path" | sed -e 's;platform/;;g')"

    printf "\n| %s ###\n" "$path"

    [ "$tree" == build ] && tree=build/make
    [ "$tree" == system/fs/fs/mgr ] && tree=system/fs/fs_mgr
    [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
    [ "$tree" == treble/app ] && tree=treble_app

    if [ ! -d "$tree" ]; then
        printf "### DIRETÓRIO NÃO ENCONTRADO / DIRECTORY NOT FOUND: %s - PULANDO / SKIPPING ###\n" "$tree"
        continue
    fi

    pushd "$tree" >/dev/null

    for patch in "$trebledroid/$path"/*.patch; do
        [ -f "$patch" ] || continue

        # Verifica se o patch já foi aplicado
        # Check whether the patch has already been applied
        if patch -f -p1 --dry-run -R < "$patch" >/dev/null 2>&1; then
            printf "### JÁ APLICADO / ALREADY APPLIED: %s ###\n" "$patch"
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
            printf "### FALHA AO APLICAR / FAILED TO APPLY: %s ###\n" "$patch"
        fi
    done

    popd >/dev/null
done

# =========================================================
# APLICANDO PATCHES ROM
# APPLYING ROM PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES ROM / APPLYING ROM PATCHES ###\n"
sleep 1.0

for path in $(cd "$rom" && echo *); do
    tree="$(tr _ / <<<"$path" | sed -e 's;platform/;;g')"

    printf "\n| %s ###\n" "$path"

    [ "$tree" == build ] && tree=build/make
    [ "$tree" == system/fs/fs/mgr ] && tree=system/fs/fs_mgr

    if [ ! -d "$tree" ]; then
        printf "### DIRETÓRIO NÃO ENCONTRADO / DIRECTORY NOT FOUND: %s - PULANDO / SKIPPING ###\n" "$tree"
        continue
    fi

    pushd "$tree" >/dev/null

    for patch in "$rom/$path"/*.patch; do
        [ -f "$patch" ] || continue

        # Verifica se o patch já foi aplicado
        # Check whether the patch has already been applied
        if patch -f -p1 --dry-run -R < "$patch" >/dev/null 2>&1; then
            printf "### JÁ APLICADO / ALREADY APPLIED: %s ###\n" "$patch"
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
            printf "### FALHA AO APLICAR / FAILED TO APPLY: %s ###\n" "$patch"
        fi
    done

    popd >/dev/null
done

# =========================================================
# APLICANDO PATCHES RELEASE-BUILDS
# APPLYING RELEASE-BUILDS PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES RELEASE-BUILDS / APPLYING RELEASE-BUILDS PATCHES ###\n"
sleep 1.0

for path in $(cd "$release_builds" && echo *); do
    tree="$(tr _ / <<<"$path" | sed -e 's;platform/;;g')"

    printf "\n| %s ###\n" "$path"

    [ "$tree" == build ] && tree=build/make
    [ "$tree" == system/fs/fs/mgr ] && tree=system/fs/fs_mgr
    [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
    [ "$tree" == treble/app ] && tree=treble_app

    if [ ! -d "$tree" ]; then
        printf "### DIRETÓRIO NÃO ENCONTRADO / DIRECTORY NOT FOUND: %s - PULANDO / SKIPPING ###\n" "$tree"
        continue
    fi

    pushd "$tree" >/dev/null

    for patch in "$release_builds/$path"/*.patch; do
        [ -f "$patch" ] || continue

        # Verifica se o patch já foi aplicado
        # Check whether the patch has already been applied
        if patch -f -p1 --dry-run -R < "$patch" >/dev/null 2>&1; then
            printf "### JÁ APLICADO / ALREADY APPLIED: %s ###\n" "$patch"
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
            printf "### FALHA AO APLICAR / FAILED TO APPLY: %s ###\n" "$patch"
        fi
    done

    popd >/dev/null
done

# =========================================================
# APLICANDO PATCHES PERSONAL-RESTLESS
# APPLYING PERSONAL-RESTLESS PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES PERSONAL-RESTLESS / APPLYING PERSONAL-RESTLESS PATCHES ###\n"
sleep 1.0

for path in $(cd "$personal_restless" && echo *); do
    tree="$(tr _ / <<<"$path" | sed -e 's;platform/;;g')"

    printf "\n| %s ###\n" "$path"

    [ "$tree" == build ] && tree=build/make
    [ "$tree" == system/fs/fs/mgr ] && tree=system/fs/fs_mgr
    [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
    [ "$tree" == treble/app ] && tree=treble_app
    [ "$tree" == vendor/partner/gms ] && tree=vendor/partner_gms

    if [ ! -d "$tree" ]; then
        printf "### DIRETÓRIO NÃO ENCONTRADO / DIRECTORY NOT FOUND: %s - PULANDO / SKIPPING ###\n" "$tree"
        continue
    fi

    pushd "$tree" >/dev/null

    for patch in "$personal_restless/$path"/*.patch; do
        [ -f "$patch" ] || continue

        # Verifica se o patch já foi aplicado
        # Check whether the patch has already been applied
        if patch -f -p1 --dry-run -R < "$patch" >/dev/null 2>&1; then
            printf "### JÁ APLICADO / ALREADY APPLIED: %s ###\n" "$patch"
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
            printf "### FALHA AO APLICAR / FAILED TO APPLY: %s ###\n" "$patch"
        fi
    done

    popd >/dev/null
done

# =========================================================
# APLICANDO PATCHES PERSONAL
# APPLYING PERSONAL PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES PERSONAL / APPLYING PERSONAL PATCHES ###\n"
sleep 1.0

for path in $(cd "$personal" && echo *); do
    tree="$(tr _ / <<<"$path" | sed -e 's;platform/;;g')"

    printf "\n| %s ###\n" "$path"

    [ "$tree" == build ] && tree=build/make
    [ "$tree" == system/fs/fs/mgr ] && tree=system/fs/fs_mgr
    [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
    [ "$tree" == treble/app ] && tree=treble_app
    [ "$tree" == vendor/partner/gms ] && tree=vendor/partner_gms

    if [ ! -d "$tree" ]; then
        printf "### DIRETÓRIO NÃO ENCONTRADO / DIRECTORY NOT FOUND: %s - PULANDO / SKIPPING ###\n" "$tree"
        continue
    fi

    pushd "$tree" >/dev/null

    for patch in "$personal/$path"/*.patch; do
        [ -f "$patch" ] || continue

        # Verifica se o patch já foi aplicado
        # Check whether the patch has already been applied
        if patch -f -p1 --dry-run -R < "$patch" >/dev/null 2>&1; then
            printf "### JÁ APLICADO / ALREADY APPLIED: %s ###\n" "$patch"
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
            printf "### FALHA AO APLICAR / FAILED TO APPLY: %s ###\n" "$patch"
        fi
    done

    popd >/dev/null
done

printf "\n### TODOS OS PATCHES FORAM PROCESSADOS / ALL PATCHES HAVE BEEN PROCESSED ###\n"
