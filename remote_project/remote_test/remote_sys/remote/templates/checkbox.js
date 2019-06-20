function getValue(){
        var IP_Info = document.getElementsByName("IP_Info");
        var value;
        for (i=0; i<IP_Info.length; i++){
                if (IP_Info[i].checked){
                        if (!value){
                                value = IP_Info[i].value;
                        } else {
                                value += "," + IP_Info[i].value;
                        }
                }
        }
        
        alert(value == undefined ? '' : value);
}


function isSelectAll(){
        var IP_Info = document.getElementsByName("IP_Info");
        for (i=0; i<IP_Info.length; i++){
                if (!IP_Info[i].checked){
                        return false;
                }
        }
        return true;
}

function selectAll(){
        var IP_Info = document.getElementsByName("IP_Info");
        if (isSelectAll()){
                for (i=0; i<IP_Info.length; i++){
                        IP_Info[i].checked = false;
                }
        } else {
                for (i=0; i<IP_Info.length; i++){
                        IP_Info[i].checked = true;
                }
        }
}

function selectOther(){
        var IP_Info = document.getElementsByName("IP_Info");
        for (i=0; i<IP_Info.length; i++){
                if (IP_Info[i].checked){
                        IP_Info[i].checked = false;
                } else {
                        IP_Info[i].checked = true;
                }
        }
}
