import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

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
        this.initial_rna_size = this.initial_rna_sequence.size();
        this.final_rna_sequence = new LinkedList<>();
        this.previous = null;
        this.correction = null;
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
            Character base = this.initial_rna_sequence.get(i);
            if (base == 'A') {
                this.initial_rna_sequence.set(i, 'U');
            }
            if (base == 'U') {
                this.initial_rna_sequence.set(i, 'A');
            }
            if (base == 'G') {
                this.initial_rna_sequence.set(i, 'C');
            }
            if (base == 'C') {
                this.initial_rna_sequence.set(i, 'G');
            }
        }
    }

    private void reverse() {
        Collections.reverse(this.final_rna_sequence);
    }

    public Boolean is_valid() {
        if (this.final_rna_sequence.isEmpty())
            return true;

        Set<Character> found = new HashSet<>();
        Character previous = null;

        for (Character character : this.final_rna_sequence) {
            if (!found.contains(character)) {
                found.add(character);
                previous = character;
            } else if (previous != character) {
                return false;
            }
        }
        return true;
    }

    @SuppressWarnings("unchecked")
    public RnaData[] next() {
        RnaData[] returnList = { null, null, null };
        if (!this.final_rna_sequence.isEmpty()) {
            if (this.correction != 'r') {
                LinkedList<Character> list2 = new LinkedList<>();
                list2 = (LinkedList<Character>) this.final_rna_sequence.clone();

                RnaData r = new RnaData(this.initial_rna_sequence, list2, this, 'r', this.initial_rna_size);
                r.reverse();
                returnList[2] = r;
            }
        }

        if (!this.initial_rna_sequence.isEmpty()) {
            LinkedList<Character> list1 = new LinkedList<>();
            list1 = (LinkedList<Character>) this.initial_rna_sequence.clone();

            LinkedList<Character> list2 = new LinkedList<>();
            list2 = (LinkedList<Character>) this.final_rna_sequence.clone();

            RnaData p = new RnaData(list1, list2, this, 'p', this.initial_rna_size);
            p.push();
            returnList[1] = p;
            if (p != null && !p.is_valid()) {
                returnList[1] = null;
            }
        }

        if (this.correction == null || this.correction != 'c') {
            LinkedList<Character> list1 = new LinkedList<>();
            list1 = (LinkedList<Character>) this.initial_rna_sequence.clone();

            RnaData c = new RnaData(list1, this.final_rna_sequence, this, 'c', this.initial_rna_size);
            c.complement();
            returnList[0] = c;
        }

        return returnList;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof RnaData)) {
            return false;
        }
        RnaData rnaData = (RnaData) o;
        return Objects.equals(initial_rna_sequence, rnaData.initial_rna_sequence)
                && Objects.equals(final_rna_sequence, rnaData.final_rna_sequence);
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
