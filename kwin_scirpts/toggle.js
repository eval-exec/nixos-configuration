function toggleClient(app_name) {
  const clients = workspace.clientList();

  let client = null;

  for (var i = 0; i < clients.length; i++) {
    let resource_name = clients[i].resourceName;

    if (resource_name == app_name) {
      client = clients[i];
      break;
    }
    if (app_name == "emacs") {
      if (resource_name == "emacs-30.0.50") {
        client = clients[i];
        break;
      }
    }
  }

  if (client) {
    if (client.desktop != workspace.currentDesktop) {
      client.desktop = workspace.currentDesktop;
      client.minimized = false;
      workspace.activeClient = client;
      console.log("app not in current desktop, activate now", app_name);
    } else {
      if (client.minimized) {
        client.minimized = false;
        workspace.activeClient = client;
        console.log(
          "in current desktop, but minimized, activate now",
          app_name,
        );
      } else {
        console.log(
          "in current desktop, but not minimized, minimized it now",
          app_name,
        );
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

function toggleAlacritty() {
  toggleClient("alacritty");
}

function toggleEmacs() {
  toggleClient("emacs");
}

registerShortcut(
  "ToggleAlacrittyWindow",
  "ToggleAlacrittyWindow",
  "Meta+F",
  toggleAlacritty,
);

registerShortcut(
  "ToggleEmacsWindow",
  "ToggleEmacsWindow",
  "Meta+S",
  toggleEmacs,
);
