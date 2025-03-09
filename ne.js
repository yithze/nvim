class Neuron {
    constructor() {
        this.weights = Array.from({ length: 10 }, () => Math.random());
        this.bias = Math.random();
    }
    activate(inputs) {
        return inputs.reduce((sum, input, i) => sum + input * this.weights[i], this.bias) > 0.5 ? 1 : 0;
    }
}

class NeuralNetwork {
    constructor(size) {
        this.neurons = Array.from({ length: size }, () => new Neuron());
    }
    predict(inputs) {
        return this.neurons.map(neuron => neuron.activate(inputs));
    }
    train(data, epochs = 100) {
        for (let epoch = 0; epoch < epochs; epoch++) {
            data.forEach(({ inputs, expected }) => {
                this.neurons.forEach(neuron => {
                    const output = neuron.activate(inputs);
                    const error = expected - output;
                    neuron.weights = neuron.weights.map((w, i) => w + error * inputs[i] * 0.01);
                    neuron.bias += error * 0.01;
                });
            });
        }
    }
}

const nn = new NeuralNetwork(5);
const trainingData = [
    { inputs: [1, 0, 1, 0, 1, 0, 1, 0, 1, 0], expected: 1 },
    { inputs: [0, 1, 0, 1, 0, 1, 0, 1, 0, 1], expected: 0 }
];

nn.train(trainingData, 500);
console.log(nn.predict([1, 0, 1, 0, 1, 0, 1, 0, 1, 0]));

