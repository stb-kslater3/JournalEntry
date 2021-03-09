
var uploadButton;

var findHeaderButton;
var headerNameInput;

//var selectDataElement;


function getFileExtension(filename) {
    let namesplit = filename.split('.');
    
    return namesplit[namesplit.length - 1];
}

function manageUpload() {
    if(uploadButton.files.length == 0) {
        displayErrorToast('No file chosen');
    }if(uploadButton.files.length > 1) {
        displayErrorToast('Only 1 file at a time please');
    }else if( getFileExtension(uploadButton.files[0].name) !== 'csv' ) {
        displayErrorToast("Bad File Type, must be a .csv file");
    }else {
        uploadButton.disabled = true;
        
        uploadButton.files[0].text().then(text => {
            apexLoadCSV(text);

            var noLoadedClasses = document.getElementsByClassName("noLoadedDiv");
            if(noLoadedClasses.length > 0) {
                for(let i = 0; i < noLoadedClasses.length; i++) {
                    noLoadedClasses[i].hidden = true;
                }
            }else {
                displayErrorToast('No class attribute named "noLoadedDiv" found');
            }
        }).catch(err => {
            if(err) {
                displayErrorToast(err);
            }else {
                displayErrorToast('If you are seeing this, then something went wrong in the JavaScript that doesn\'t provide an error message. Let me know and so that I can figure it out');
            }
        });
    }
}


function manageDataSelection() {
    var selectDataElement = document.getElementById("dataToInsertSelect");

    if(selectDataElement.value === "PreReconciled") {
        setPreReconciled(true);
    }else {
        setPreReconciled(false);
    }
}


window.onload = function() {
    uploadButton = document.getElementById("uploadButton");
    uploadButton.onchange = function() {
        manageUpload();
    };


    headerNameInput = document.getElementById("headerNameInput");
    findHeaderButton = document.getElementById("findHeaderButton");
    findHeaderButton.onclick = function() {
        findHeaderId(headerNameInput.value);
    };

 /*   
    selectDataElement = document.getElementById("dataToInsertSelect");
    selectDataElement.value = "PostReconciled";
    selectDataElement.onchange = function() {
        manageDataSelection();
    };
*/
};

