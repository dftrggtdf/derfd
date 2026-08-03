let currentFile = null;
let currentData = null;
let selectedNode = null;

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


    if (!node.id) {
        node.id = "node_" + Math.random().toString(36).slice(2);
    }


    html += `
        <div class="node"
             data-node-id="${node.id}"
             style="
             left:${x}px;
             top:${y}px;
             "
             onclick="selectNode('${node.id}')">

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







function selectNode(id) {


    document.querySelectorAll(".node").forEach(node => {
        node.classList.remove("selected");
    });



    const element = document.querySelector(
        `[data-node-id="${id}"]`
    );



    if (element) {
        element.classList.add("selected");
    }



    selectedNode = id;


    console.log("Selected node:", selectedNode);
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









document.getElementById("create").onclick = async () => {


    currentData = {

        formatVersion: 3,

        id: "root",

        title: "New Mind Map",

        ideas: {}

    };




    currentFile = await window.showSaveFilePicker({

        suggestedName: "new_mindmap",

        types: [
            {
                description: "Mind Map JSON",

                accept: {
                    "application/json": [".json"]
                }

            }
        ]

    });




    let filename = currentFile.name;



    if (!filename.endsWith(".json")) {

        console.log(
            "Will be treated as JSON"
        );

    }





    const writable = await currentFile.createWritable();



    await writable.write(
        JSON.stringify(currentData, null, 2)
    );



    await writable.close();





    document.getElementById("output").innerHTML =
        renderTree(currentData);



    console.log(
        "Created:",
        currentFile.name
    );

};









document.getElementById("save").onclick = async () => {


    if (!currentFile) {

        alert(
            "No file loaded"
        );

        return;

    }




    const writable =
        await currentFile.createWritable();




    await writable.write(

        JSON.stringify(
            currentData,
            null,
            2
        )

    );




    await writable.close();



    alert(
        "Saved!"
    );

};