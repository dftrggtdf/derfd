let currentFile = null;
let currentData = null;


function renderTree(node, level = 0) {
    let html = "";

    html += `
        <div class="node" style="margin-left:${level * 25}px">
            ${node.title || "No title"}
        </div>
    `;

    if (node.ideas) {
        for (const child of Object.values(node.ideas)) {
            html += renderTree(child, level + 1);
        }
    }

    return html;
}


document.getElementById("open").onclick = async () => {

    [fileHandle] = await window.showOpenFilePicker({
        types: [
            {
                description: "JSON files",
                accept: {
                    "application/json": [".json"]
                }
            }
        ]
    });

    currentFile = fileHandle;

    const file = await currentFile.getFile();
    const text = await file.text();

    currentData = JSON.parse(text);


    document.getElementById("output").innerHTML =
        renderTree(currentData);


    console.log("Loaded:", currentFile.name);
};



document.getElementById("save").onclick = async () => {

    if (!currentFile) {
        alert("No file loaded");
        return;
    }

    const writable = await currentFile.createWritable();

    await writable.write(
        JSON.stringify(currentData, null, 2)
    );

    await writable.close();

    alert("Saved!");
};