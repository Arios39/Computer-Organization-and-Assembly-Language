void proc() {
	int a = 0;
}

void swap (int *px, int *py) {
    int *temp;
    *temp = *px;
    *px = *py;
    *py = *temp;
}

int main () {
    int a = 1, b = 2;
    proc();
    swap(&a, &b); 
}