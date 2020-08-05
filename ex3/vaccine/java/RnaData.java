public class RnaData {
    String initial_rna_sequence;
    String final_rna_sequence;
    RnaData previous;
    Character correction;
    int initial_rna_size;

    public RnaData(String initial_rna_sequence, String final_rna_sequence, RnaData previous, Character correction,
            int initial_rna_size) {
        this.initial_rna_sequence = initial_rna_sequence;
        this.final_rna_sequence = final_rna_sequence;
        this.previous = previous;
        this.correction = correction;
        this.initial_rna_size = initial_rna_size;
    }

    public RnaData(String initial_rna_sequence) {
        this.initial_rna_sequence = initial_rna_sequence;
        this.final_rna_sequence = null;
        this.previous = null;
        this.correction = null;
        // this.initial_rna_size = initial_rna_size; // WARNING:
    }

    private void push() {

    }

    private void complement() {

    }

    private void reverse() {

    }

    public Boolean is_valid() {

    }

    private void next() {

    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        RnaData other = (RnaData) o;
        // return this.x == other.x && this.y == other.y;
    }

    @Override
    public int hashCode() {
        // return Objects.hash(x, y);
    }
}
