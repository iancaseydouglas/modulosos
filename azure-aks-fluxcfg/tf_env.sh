#!/bin/bash

# Centralized configuration file definitions
CONFIG_FILE_TEMPLATE="${TF_ENV_CONFIG_DIR:-.}/%s.tfvars"
BACKEND_FILE_TEMPLATE="${TF_ENV_CONFIG_DIR:-.}/%s-backend.tfvars"

function tf_env_help() {
    cat << EOF
Usage: tf_env <command> [environment]

Commands:
  <environment>  Activate the specified environment
  deactivate     Deactivate the current environment
  help           Display this help message

Environment Activation:
  When activating an environment, tf_env looks for the following files:
    1. $(printf "$CONFIG_FILE_TEMPLATE" "<environment>")
       Contains Terraform variables specific to the environment.

    2. $(printf "$BACKEND_FILE_TEMPLATE" "<environment>")
       Contains backend configuration for the environment.

  Both files are required for proper environment setup.

Environment Variable:
  TF_ENV_CONFIG_DIR: Set this to specify a custom directory for config files.
                     Default is the current directory.

Examples:
  tf_env prod           # Activate production environment
  tf_env stage          # Activate staging environment
  tf_env deactivate     # Deactivate current environment

Note: This script can be sourced for interactive use or run directly.
When sourced, it provides additional shell integration (prompt changes, aliases).
EOF
}

function terraform_wrapper() {
    printf "(running '%s' in '%s')\n" "$1" "$TF_VAR_environment"
    command terraform "$@"
}

function tf_env_activate() {
    local environment=$1
    local config_file=$(printf "$CONFIG_FILE_TEMPLATE" "$environment")
    local backend_file=$(printf "$BACKEND_FILE_TEMPLATE" "$environment")

    if [[ ! -f "$config_file" ]]; then
        printf "Error: Environment file '%s' not found.\n" "$config_file"
        printf "Please ensure this file exists in the specified directory.\n"
        tf_env_help
        return 1
    fi

    if [[ ! -f "$backend_file" && -z "$TF_BACKEND_CONFIG" ]]; then
        printf "Error: Backend configuration file '%s' not found.\n" "$backend_file"
        printf "Please ensure this file exists in the specified directory.\n"
        tf_env_help
        return 1
    fi

    export TF_VAR_environment="$environment"
    
    # Secretly allow TF_BACKEND_CONFIG override
    local backend_config=${TF_BACKEND_CONFIG:-"-backend-config=$backend_file"}

    # Set arguments for init, plan, and apply
    export TF_CLI_ARGS_init="$backend_config"
    export TF_CLI_ARGS_plan="-var-file=$config_file $backend_config"
    export TF_CLI_ARGS_apply="-var-file=$config_file $backend_config"

    if [[ "$SOURCED" == "true" ]]; then
        export PS1="($environment) $PS1"
        alias terraform='terraform_wrapper'
        alias tf='terraform_wrapper'
    fi

    printf "%s environment activated. Terraform commands will now use %s configuration.\n" "$environment" "$environment"
}

function tf_env_deactivate() {
    if [[ -z "$TF_VAR_environment" ]]; then
        printf "No active environment to deactivate.\n"
        tf_env_help
        return 1
    fi

    local current_env=$TF_VAR_environment
    unset TF_VAR_environment
    unset TF_CLI_ARGS_init
    unset TF_CLI_ARGS_plan
    unset TF_CLI_ARGS_apply

    if [[ "$SOURCED" == "true" ]]; then
        unalias terraform 2>/dev/null
        unalias tf 2>/dev/null
        export PS1="${PS1#*(*) }"
    fi

    printf "%s environment deactivated.\n" "$current_env"
}

function tf_env() {
    case "$1" in
        deactivate)
            tf_env_deactivate
            ;;
        help)
            tf_env_help
            ;;
        "")
            printf "Error: No command provided.\n"
            tf_env_help
            return 1
            ;;
        *)
            tf_env_activate "$1"
            ;;
    esac
}

# Determine if the script is being sourced or run directly
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    SOURCED=true
else
    SOURCED=false
    tf_env "$@"
fi
