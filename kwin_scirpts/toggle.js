function toggleClient(app_name) {
  const getMethods = (obj) => {
    let properties = new Set();
    let currentObj = obj;
    do {
      Object.getOwnPropertyNames(currentObj).map((item) =>
        properties.add(item)
      );
    } while ((currentObj = Object.getPrototypeOf(currentObj)));
    return [...properties.keys()].filter((item) =>
      typeof obj[item] === "function"
    );
  };

  console.log("in toggle client", app_name);
  let clients = workspace.windowList();

  let client = null;

  for (var i = 0; i < clients.length; i++) {
    let resource_name = clients[i].resourceName;
    console.log(resource_name);

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
  // console.log("workspace : methods: ", getMethods(workspace));
  // console.log("workspace : keys: ", Object.keys(workspace));

  if (client) {
    // console.log("clients: methods: ", getMethods(client));
    // console.log("clients: keys: ", Object.keys(client));

    // console.log(
    //   "currentdesktop : methods: ",
    //   getMethods(workspace.currentDesktop),
    // );
    // console.log(
    //   "currentdesktop: keys: ",
    //   Object.keys(workspace.currentDesktop),
    // );

    // console.log("on current desktop: ", client.active);
    // console.log("client.desktopWindow", client.desktopWindow);

    // if (client.desktop() != workspace.currentDesktop) {
    if (!client.active) {
      // client.desktopWindow = true;
      // client.desktop = workspace.currentDesktop.id;
      // client.minimized = false;
      workspace.activeWindow = client;
      console.log("app not in current desktop, activate now", app_name);
    } else {
      if (client.minimized) {
        // client.minimized = false;
        workspace.activeWindow = client;
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

function toggleChrome() {
  toggleClient("chrome");
}

{
  let registed = registerShortcut(
    "ToggleAlacrittyWindow",
    "ToggleAlacrittyWindow",
    "Meta+F",
    toggleAlacritty,
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
