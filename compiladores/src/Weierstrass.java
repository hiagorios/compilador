import java.util.Arrays;

class Weierstrass {

    public static void main(String[] args) {
        Weierstrass w = new Weierstrass();
        System.out.println(w.calculate(new double[]{0, 0, 0}));
    }

    public double calculate(double[] x) {
        double pi2 = Math.PI * 2.0;
        double kFinal = 11;
        int dimension = x.length;
        double result = 0.0;

        if (dimension <= 1) {
            throw new RuntimeException("x dimension cannot be 1 or less");
        }

        double[] z = generateZ(0.01, x);
        System.out.println("Vector z");
        System.out.println(Arrays.toString(z));

        //Calculando f0
        double f0 = 0.0;
        for (int k = 0; k <= kFinal; k++) {
            f0 += (1 / Math.pow(2, k)) * Math.cos(pi2 * Math.pow(3, k) * 0.5);
        }

        //Calculando os somatórios
        double sum = 0.0;

        for (int i = 1; i <= dimension; i++) {
            for (int k = 0; k <= kFinal; k++) {
                sum += (1 / Math.pow(2, k)) * Math.cos(pi2 * Math.pow(3, k) * (z[i] + 0.5));
            }
            //f0 está fora do somatório interno mas dentro do somatório externo
            sum -= f0;
        }

        result = (1 / (float) dimension) * sum;
        result = 10 * Math.pow(result, 3);

        result += (10 / (float) dimension) * fpen(x);
        return result;
    }

    public double[] generateZ(double alfa, double[] x) {
        double[][] matrixAlfa = generateMatrixAlfa(alfa, x.length);
//        System.out.println("Matrix Alfa");
//        System.out.println(Arrays.deepToString(matrixAlfa));
        double[][] matrixR = RotationFunction.cocoRandUniforme(x.length, 13);
//        System.out.println("Matrix R");
//        System.out.println(Arrays.deepToString(matrixR));
        double[][] rAlfa = multiply(matrixR, matrixAlfa);
//        System.out.println("Matrix RAlfa");
//        System.out.println(Arrays.deepToString(rAlfa));
        double[] qTosz = generateQTosz(x, matrixR);
//        System.out.println("Vector QTosz");
//        System.out.println(Arrays.toString(qTosz));
        return multiply(rAlfa, qTosz);
    }

    public double[][] generateMatrixAlfa(double alfa, int dimension) {
        double[][] matrixAlfa = new double[dimension][dimension];

        for (int i = 0; i < dimension; i++) {
            matrixAlfa[i][i] = Math.pow(alfa, (0.5 * (i - 1) / (dimension - 1)));
        }
        return matrixAlfa;
    }

    public double[] generateQTosz(double[] x, double[][] matrixR) {
        double[][] matrixQ = RotationFunction.cocoRandUniforme(x.length, 1000000);
//        System.out.println("Matrix Q");
//        System.out.println(Arrays.deepToString(matrixQ));
        double[] rx = multiply(matrixR, x);
        System.out.println("Vector Rx");
        System.out.println(Arrays.toString(rx));
        double[] tosz = tosz(rx);
        System.out.println("Vector Tosz");
        System.out.println(Arrays.toString(tosz));

        return multiply(matrixQ, tosz);
    }

    public double[] tosz(double[] input) {
        double[] output = new double[input.length];

        for (int i = 0; i < input.length; i++) {
            double c1 = 5.5, c2 = 3.1, xCaret = 0, signX = 0, x = input[i];
            if (x != 0) {
                xCaret = Math.log(Math.abs(x));
                if (x > 0) {
                    signX = 1;
                    c1 = 10;
                    c2 = 7.9;
                } else {
                    signX = -1;
                }
            }
            output[i] = signX * Math.exp(xCaret + 0.049 * (Math.sin(c1 * xCaret) + Math.sin(c2 * xCaret)));
        }
        return output;
    }

    public double fpen(double[] x) {
        double d = x.length;
        double sum = 0.0;
        for (int i = 1; i <= d; i++) {
            double max = Math.abs(x[i]) - 5;
            sum += max > 0 ? Math.pow(max, 2) : 0;
        }
        return sum;
    }

    public double[][] multiply(double[][] a, double[][] b) {
        double[][] result = new double[a.length][b[0].length];
        for (int row = 0; row < result.length; row++) {
            for (int col = 0; col < result[row].length; col++) {
                result[row][col] = 0;
                for (int i = 0; i < b.length; i++) {
                    result[row][col] += a[row][i] * b[i][col];
                }
            }
        }
        return result;
    }

    public double[] multiply(double[][] matrix, double[] vector) {
        double[] result = new double[matrix.length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[0].length; j++) {
                result[i] += matrix[i][j] * vector[j];
            }
        }
        return result;
    }
}
