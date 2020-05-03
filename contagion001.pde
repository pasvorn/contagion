// number of People
final int N = 800;

int framenumber = 0;
People[] p1 = new People[N];
// PrinterWrite is for saving output for analysis
PrintWriter output;
/**
We use randomSeed() call so we can repeat experiment with different
parameters.
*/
void setup() {
 size(1000,640); 
 randomSeed(1);
 frameRate(20);
 for(int i=0; i < N; i++) {
   p1[i] = new People(i);
 }
 p1[0].getsick(1);
 String filename = "src/data" + ".csv";
 output = createWriter(filename);
 output.println("Frame,Well,Sick,Recovered");
}

void draw() {
  background(255);
  int sick_count = 0;
  int immuned_count = 0;
  int well_count = 0;
  for(int i=0; i < N; i++) {
    People person1 = p1[i];
    if ( person1.mycolor == person1.well_color ) well_count ++;
    else if (person1.mycolor == person1.sick_color) sick_count++;
    else if (person1.mycolor == person1.immune_color) immuned_count++;

    for (int j=i+1; j < N; j++) {
      People person2 = p1[j];
      if( person1.meet(person2) ) {
        person1.contact(person2);
      }
    }
    p1[i].move(framenumber);
    p1[i].draw();
  }

  framenumber += 1;
  output.println(framenumber + "," + well_count + "," +
    sick_count + "," +immuned_count);
  if( sick_count <= 0) {
    output.flush();
    output.close();
    exit();
  }
}
