function buildNeural(data) {
	const config = {
		binaryThresh: 0.5,
    	hiddenLayers: [3],     // array of ints for the sizes of the hidden layers in the network
    	activation: 'sigmoid'  // supported activation types: ['sigmoid', 'relu', 'leaky-relu', 'tanh']
	};

	// create a simple feed forward neural network with backpropagation
	const net = new brain.NeuralNetwork(config);

	//training datas 
	var trainingSet = [], caso = {};
	
	for (var i =0; i < data.length ; i++) {
		var object = {
			
				input: {salario: data[i].salario, idade: data[i].idade, emprestimo: data[i].emprestimo},
				output: {rotulo: data[i].rotulo}
				
			}
			trainingSet[i] = object;
		}

		net.train(trainingSet);
		//neural test
	$('#verificar').on('click',function () {
		caso = {salario: parseInt($('#salario').val()), idade: parseInt($('#idade').val()), emprestimo: parseInt($('#emprestimo').val())};
		var output = net.run(caso);
		// console.log(caso);
		// console.log(output);
		document.getElementById('neuralPrediction').innerHTML = JSON.stringify(output, null, 0); 	
	});	

}