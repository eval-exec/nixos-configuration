function toggleClient(app_name) {
    const getMethods = (obj) => {
        let properties = new Set();
        let currentObj = obj;
        do {
            Object.getOwnPropertyNames(currentObj).map((item) =>
                properties.add(item),
            );
        } while ((currentObj = Object.getPrototypeOf(currentObj)));
        return [...properties.keys()].filter(
            (item) => typeof obj[item] === "function",
        );
    };

    // console.log("in toggle client", app_name);
    let clients = workspace.windowList();

    let client = null;

    for (var i = 0; i < clients.length; i++) {
        let resource_name = clients[i].resourceName;
        // console.log("resource name: ", resource_name);

        if (resource_name == app_name) {
            client = clients[i];
            break;
        }
        if (app_name == "emacs") {
            if (resource_name == "emacs-31.0.50") {
                client = clients[i];
                break;
            }
        }
    }
    if (client) {
        if (!client.active) {
            workspace.activeWindow = client;
        } else {
            if (client.minimized) {
                workspace.activeWindow = client;
            } else {
                client.minimized = true;
            }
        }
    } else {
        console.log("not found target client, we theses:", app_name);
        for (var i = 0; i < clients.length; i++) {
            let resource_name = clients[i].resourceName;
            console.log("we have ", resource_name);
        }
    }
}

function toggleTerm() {
    toggleClient("kitty");
}

function toggleEmacs() {
    toggleClient("emacs");
}

function toggleChrome() {
    toggleClient("google-chrome");
}

function toggleChatGPT() {
    toggleClient("crx_cadlkienfkclaiaibeoongdcgmdikeeg");
}

{
    let registed = registerShortcut(
        "ToggleTermWindow",
        "ToggleTermWindow",
        "Meta+F",
        toggleTerm,
    );
    if (registed) {
        console.log("registed alacritty");
    } else {
        console.log("failed to registed alacritty");
    }
}

{
    let registed = registerShortcut(
        "ToggleChromeWindow",
        "ToggleChromeWindow",
        "Meta+W",
        toggleChrome,
    );
    if (registed) {
        console.log("registed chrome");
    } else {
        console.log("failed to registed chrome");
    }
}
{
    let registed = registerShortcut(
        "ToggleEmacsWindow",
        "ToggleEmacsWindow",
        "Meta+S",
        toggleEmacs,
    );

    if (registed) {
        console.log("registed emacs");
    } else {
        console.log("failed to registed emacs");
    }
}

{
    let registed = registerShortcut(
        "ToggleChatGPT",
        "ToggleChatGPT",
        "Meta+C",
        toggleChatGPT,
    );

    if (registed) {
        console.log("registed ChatGPT");
    } else {
        console.log("failed to registed ChatGPT");
    }
}
