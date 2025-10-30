function toggleClient(p_app_name, p_desktopFileName) {	
	console.log("try to toggle", p_app_name, p_desktopFileName)
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

  let clients = workspace.windowList();

  let client = null;

  for (var i = 0; i < clients.length; i++) {
    let resource_name = clients[i].resourceName;
    let caption = clients[i].caption;
    let desktopFileName = clients[i].desktopFileName;
	
    if (p_desktopFileName) {
      if (resource_name == p_app_name && desktopFileName.startsWith(p_desktopFileName)) {
        client = clients[i];
	    console.log("found", resource_name, ", caption:" , caption, ", desktopFileName: ", desktopFileName);
        break;
      }
    } else {
      if (resource_name == p_app_name) {
        client = clients[i];
	    console.log("found", resource_name, ", caption:" , caption, ", desktopFileName: ", desktopFileName);
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
    console.log("not found target client ",p_app_name, p_caption, ", we theses:", p_app_name);
    for (var i = 0; i < clients.length; i++) {
      let resource_name = clients[i].resourceName;
    let caption = clients[i].caption;
      console.log("we have: ", resource_name.padEnd(20), ", caption: ", caption);
    }
  }
}

function toggleTerm() {
  toggleClient("kitty");
}

function toggleEmacs() {
  toggleClient("emacs");
}

function toggleOkular() {
  toggleClient("okular");
}

function toggleChrome() {
  toggleClient("chrome");
}

 function toggleChatGPT() {
-  toggleClient("chrome", "chrome-cadlk");
 }
 
 function toggleClaude() {
-  toggleClient("chrome", "chrome-fmpnliohjhemenmnlpbfagaolkdacoja-Default");
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
    "ToggleClaude",
    "ToggleClaude",
    "Meta+8",
    toggleClaude,
  );

  if (registed) {
    console.log("registed ChatGPT");
  } else {
    console.log("failed to registed ChatGPT");
  }
}
{
  let registed = registerShortcut(
    "ToggleChatGPT",
    "ToggleChatGPT",
    "Meta+9",
    toggleChatGPT,
  );

  if (registed) {
    console.log("registed ChatGPT");
  } else {
    console.log("failed to registed ChatGPT");
  }
}

{
  let registed = registerShortcut(
    "ToggleOkularWindow",
    "ToggleOkularWindow",
    "Meta+U",
    toggleOkular,
  );

  if (registed) {
    console.log("registed okular");
  } else {
    console.log("failed to registed okular");
  }
}
