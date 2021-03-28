public class Weierstrass {

    public static double calculate(double[] x) {
        double pi2 = Math.PI * 2.0;
        double kFinal = 11;
        double d = x.length;
        double result = 0.0;
        double fopt = 0.0;

        double sum = 0.0;
        for (int i = 1; i <= d; i++) {
            for (int k = 0; k <= kFinal; k++) {
                sum += (1 / Math.pow(2, k)) * Math.cos(pi2 * Math.pow(3, k) * (x[i] + 0.5));
            }
        }

        double f0 = 0.0;
        for (int k = 0; k <= kFinal; k++) {
            f0 += (1 / Math.pow(2, k)) * Math.cos(pi2 * Math.pow(3, k) * 0.5);
        }

        result = (1 / d) * sum - f0;
        result = 10 * Math.pow(result, 3);

        result += (10 / d) * fpen(x) + fopt;
        return result;
    }

    private static double fpen(double[] x) {
        double d = x.length;
        double sum = 0.0;
        for (int i = 1; i <= d; i++) {
            double max = Math.abs(x[i]) - 5;
            sum += max > 0 ? Math.pow(max, 2) : 0;
        }
        return sum;
    }
}
