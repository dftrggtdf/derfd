let currentFile = null;
let currentData = null;

let nodeSpacingY = 80;


function calculateHeight(node) {
    if (!node.ideas) {
        return 1;
    }

    let total = 0;

    for (const child of Object.values(node.ideas)) {
        total += calculateHeight(child);
    }

    return Math.max(total, 1);
}



function renderTree(node, depth = 0, yStart = 0) {

    let html = "";

    let height = calculateHeight(node);

    let x = 800 + depth * 250;
    let y = yStart + (height * nodeSpacingY) / 2;


    html += `
        <div class="node"
             style="
             left:${x}px;
             top:${y}px;
             ">
            ${node.title || "No title"}
        </div>
    `;


    if (node.ideas) {

        let currentY = yStart;

        for (const child of Object.values(node.ideas)) {

            html += renderTree(
                child,
                depth + 1,
                currentY
            );

            currentY += calculateHeight(child) * nodeSpacingY;
        }
    }


    return html;
}



document.getElementById("open").onclick = async () => {

    const [fileHandle] = await window.showOpenFilePicker({
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