final int N = 2000;

int framenumber = 0;
People[] p1 = new People[N];

void setup() {
 size(2000,1000); 
 frameRate(20);
 for(int i=0; i < N; i++) {
   p1[i] = new People(i);
 }
 p1[0].getsick(1);
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
        /* 
        if( person1.sicked() ) {
          if( !person2.sicked() ) {
            if( random(0,1.0) < 0.4) person2.getsick(framenumber);
          }
        } else if ( person2.sicked()) {
          if ( random(0,1.0) < 0.4) person1.getsick(framenumber);
        } */
      }
    }
    p1[i].move(framenumber);
    p1[i].draw();
  }

  framenumber += 1;
  println(framenumber,well_count, sick_count, immuned_count);
  if( sick_count <= 0) exit();
}
