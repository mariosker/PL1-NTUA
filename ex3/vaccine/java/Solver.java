import java.util.ArrayDeque;
import java.util.HashSet;
import java.util.Queue;
import java.util.Set;

public class Solver {
    RnaData initial_rna;

    public Solver(String initial_rna) {
        this.initial_rna = new RnaData(initial_rna);
    }

    public void BFS() { // ATTENTION:
        Set<RnaData> seen = new HashSet<>();
        Queue<RnaData> remaining = new ArrayDeque<>();

        remaining.add(this.initial_rna);
        seen.add(this.initial_rna);

        while (!remaining.isEmpty()) {
            RnaData s = remaining.remove();

            if (s.getInitial_rna_size() == 0)
                System.out.println("yes");

            for (RnaData n : s.next()) {
                if (n != null && !seen.contains(n)) {
                    remaining.add(n);
                    seen.add(n);
                }
            }
        }
        return;
    }
}
