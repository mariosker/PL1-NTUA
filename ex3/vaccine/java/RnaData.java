import java.util.*;

public class RnaData {
    LinkedList<Character> initial_rna_sequence;
    LinkedList<Character> final_rna_sequence;
    RnaData previous;
    Character correction;
    int initial_rna_size;

    public RnaData(LinkedList<Character> initial_rna_sequence, LinkedList<Character> final_rna_sequence,
            RnaData previous, Character correction, int initial_rna_size) {
        this.initial_rna_sequence = initial_rna_sequence;
        this.final_rna_sequence = final_rna_sequence;
        this.previous = previous;
        this.correction = correction;
        this.initial_rna_size = initial_rna_size;
    }

    public RnaData(String initial_rna_sequence) {
        this.initial_rna_sequence = new LinkedList<>();
        for (int i = 0; i < initial_rna_sequence.length(); i++) {
            this.initial_rna_sequence.add(initial_rna_sequence.charAt(i));
        }
        this.final_rna_sequence = new LinkedList<>();
        this.previous = null;
        this.correction = null;
        this.initial_rna_size = this.initial_rna_sequence.size();
    }

    private void push() {
        if (this.initial_rna_size == 0) {
            return;
        }
        Character base = this.initial_rna_sequence.removeLast();
        this.final_rna_sequence.add(base);
        this.initial_rna_size--;
    }

    private void complement() {
        for (int i = 0; i < this.initial_rna_size; i++) {
            this.initial_rna_sequence.set(i, Globals.complements.get(this.initial_rna_sequence.get(i)));
        }
    }

    private void reverse() {
        Collections.reverse(this.final_rna_sequence);
    }

    // public Boolean is_valid() {

    // }

    // public void next() {

    // }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof RnaData)) {
            return false;
        }
        RnaData rnaData = (RnaData) o;
        return Objects.equals(initial_rna_sequence, rnaData.initial_rna_sequence)
                && Objects.equals(final_rna_sequence, rnaData.final_rna_sequence)
    }

    @Override
    public int hashCode() {
        return Objects.hash(initial_rna_sequence, final_rna_sequence);
    }

    public LinkedList<Character> getInitial_rna_sequence() {
        return this.initial_rna_sequence;
    }

    public LinkedList<Character> getFinal_rna_sequence() {
        return this.final_rna_sequence;
    }

    public RnaData getPrevious() {
        return this.previous;
    }

    public Character getCorrection() {
        return this.correction;
    }

    public int getInitial_rna_size() {
        return this.initial_rna_size;
    }

}
