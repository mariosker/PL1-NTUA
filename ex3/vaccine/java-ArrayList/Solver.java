import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Queue;
import java.util.Set;

public class Solver {
    RnaData initial_rna;

    public Solver(String initial_rna) {
        this.initial_rna = new RnaData(initial_rna);
    }

    public void BFS() {
        Set<RnaData> seen = new HashSet<>();
        Queue<RnaData> remaining = new ArrayDeque<>();

        remaining.add(this.initial_rna);
        seen.add(this.initial_rna);

        while (!remaining.isEmpty()) {
            RnaData s = remaining.remove();

            if (s.getInitial_rna_size() == 0) {
                PrintSteps(s);
                return;
            }

            for (RnaData n : s.next()) {
                if (n != null && !seen.contains(n)) {
                    remaining.add(n);
                    seen.add(n);
                }
            }
        }
        return;
    }

    private void PrintSteps(RnaData final_rna) {
        List<Character> steps = new ArrayList<>();
        while (final_rna.correction != null) {
            steps.add(final_rna.correction);
            final_rna = final_rna.previous;
        }
        Collections.reverse(steps);
        StringBuilder sb = new StringBuilder();
        for (Character ch : steps) {
            sb.append(ch);
        }
        String string = sb.toString();
        System.out.println(string);
    }
}
