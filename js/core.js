$(document).ready(function() {
    //datas loading...
    $.ajax({
        type: "GET",
        url: "credit_data.csv",
        dataType: "text",
        success: function(data) {
            //.csv to array
            data = $.csv.toObjects(data);
            processData(data);
            allInt(data);
            buildForest(data);
            buildNeural(data);
        }
     });
});
//clean uninteresting variables
function processData(data) {
    for (var i = 0; i < data.length; i++) {
        delete data[i].cliente_id;
        for (var propriedade in data[i]) {
          if (data[i][propriedade]=== "" || parseFloat(data[i][propriedade].replace(',','.'))< 0) {
            //remove line
            data.splice(i,1);
            i=0;
            break;
          }
        }
    }
}

function allInt(data) {
    for (var i = 0; i < data.length; i++) {
        for (var propriedade in data[i]) {
            data[i][propriedade] = parseInt(data[i][propriedade]);
             //data[i][propriedade] = parseFloat(data[i][propriedade].replace(',','.')).toFixed(2);
        }
    }
}