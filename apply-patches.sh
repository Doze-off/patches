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
# FUNÇÃO PARA RESOLVER O DIRETÓRIO DA ÁRVORE
# FUNCTION TO RESOLVE THE TREE DIRECTORY
# =========================================================

resolve_tree() {
    local path="$1"
    local tree
    tree="$(tr _ / <<<"$path" | sed -e 's;platform/;;g')"

    case "$tree" in
        build)
            tree="build/make"
            ;;
        system/fs/fs/mgr)
            tree="system/fs/fs_mgr"
            ;;
        vendor/partner/gms)
            tree="vendor/partner_gms"
            ;;
        prebuilts/module/sdk/Profiling)
            tree="prebuilts/module_sdk/Profiling"
            ;;
    esac

    printf '%s\n' "$tree"
}

# =========================================================
# APLICANDO PATCHES TREBLEDROID
# APPLYING TREBLEDROID PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES TREBLEDROID / APPLYING TREBLEDROID PATCHES ###\n"
sleep 1.0

for path in $(cd "$trebledroid" && echo *); do
    tree="$(resolve_tree "$path")"

    printf "\n| %s ###\n" "$path"

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
    tree="$(resolve_tree "$path")"

    printf "\n| %s ###\n" "$path"

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
# APLICANDO PATCHES PERSONAL-RESTLESS
# APPLYING PERSONAL-RESTLESS PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES PERSONAL-RESTLESS / APPLYING PERSONAL-RESTLESS PATCHES ###\n"
sleep 1.0

for path in $(cd "$personal_restless" && echo *); do
    tree="$(resolve_tree "$path")"

    printf "\n| %s ###\n" "$path"

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
    tree="$(resolve_tree "$path")"

    printf "\n| %s ###\n" "$path"

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

# =========================================================
# APLICANDO PATCHES RELEASE-BUILDS
# APPLYING RELEASE-BUILDS PATCHES
# =========================================================

printf "\n### APLICANDO PATCHES RELEASE-BUILDS / APPLYING RELEASE-BUILDS PATCHES ###\n"
sleep 1.0

for path in $(cd "$release_builds" && echo *); do
    tree="$(resolve_tree "$path")"

    printf "\n| %s ###\n" "$path"

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

printf "\n### TODOS OS PATCHES FORAM PROCESSADOS / ALL PATCHES HAVE BEEN PROCESSED ###\n"
