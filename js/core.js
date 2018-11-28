$(document).ready(function() {
    //Requisitar os dados
    $.ajax({
        type: "GET",
        url: "credit_data.csv",
        dataType: "text",
        success: function(data) {
            //Trasnformar csv em um array de objetos
            data = $.csv.toObjects(data);
            processData(data);
            allInt(data);
            buildForest(data);
            buildNeural(data);
        }
     });
});
//remove a coluna id e verifica se os dados são válidos
function processData(data) {
    for (var i = 0; i < data.length; i++) {
        delete data[i].cliente_id;
        for (var propriedade in data[i]) {
          if (data[i][propriedade]=== "" || parseFloat(data[i][propriedade].replace(',','.'))< 0) {
            // console.log(propriedade);
            //remove dado da base
            data.splice(i,1);
            i=0;
            break;
          }
        }//fim for propriedades
    }//fim for todos os registros
}

function allInt(data) {
    for (var i = 0; i < data.length; i++) {
        for (var propriedade in data[i]) {
            data[i][propriedade] = parseInt(data[i][propriedade]);
             //data[i][propriedade] = parseFloat(data[i][propriedade].replace(',','.')).toFixed(2);
        }
    }
}