if command -v az >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    export ZSH_AZURE_PLUGIN_ENABLE="True"
else
    echo "Azure CLI plugin is disabled."
fi

function azure_prompt_info() {
    if [ "$ZSH_AZURE_PLUGIN_ENABLE" != "True" ]; then
        return
    fi

    JQ_TEMPLATE='.subscriptions[] | select(.isDefault == true) | [.name, .user.name] | join("|")'
    if [[ -e .azure-config/azureProfile.json ]]; then
        context=$(cat .azure-config/azureProfile.json | jq $JQ_TEMPLATE)
        context=${context//\"/}
        echo "$context"
    elif [[ -e $HOME/.azure/azureProfile.json ]]; then
        context=$(cat $HOME/.azure/azureProfile.json | jq $JQ_TEMPLATE)
        context=${context//\"/}
        echo "\xE2\x98\x81 $context"
    fi
}

function enter_azure_context() {
    if [ "$ZSH_AZURE_PLUGIN_ENABLE" != "True" ]; then
        return
    fi

    if [[ -d .azure-config ]]; then
        export AZURE_CONFIG_DIR="$(cd .azure-config; pwd)"
    else
        unset AZURE_CONFIG_DIR
    fi
}

chpwd_functions+=(enter_azure_context)
