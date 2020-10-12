import controlP5.*;

ControlP5 cp5;
float colorred;
float colorgreen;
float colorblue;
float sliderValue;
float alphaValue;
boolean toggleValue;
boolean lasttoggleValue;

color nowcolor;
int isdrag = 0;
int bx,by;
int mx = 800;

void setup() {
	size(960, 600);
	background(0,60,20);
	smooth();
	frameRate(60);
	cp5 = new ControlP5(this);
	
	cp5.addKnob("colorred") // left knob
		.setLabel("RED")
		.setRange(0, 255)
		.setValue(255)
		.setPosition(800, 30)
		.setRadius(50)
		.setColorBackground(color(200))
		.setColorActive(color(colorred,0,0,100))
		.setColorForeground(color(255,0,0,255))
		.setColorValueLabel(color(255,0,0))
		.setNumberOfTickMarks(25)
		.snapToTickMarks(true);
	
	cp5.addKnob("colorgreen") // center knob
		.setLabel("GREEN")
		.setRange(0, 255)
		.setValue(255)
		.setPosition(800, 180)
		.setRadius(50)
		.setColorBackground(color(200))
		.setColorActive(color(0,colorgreen,0,100))
		.setColorForeground(color(0,255,0,255))
		.setColorValueLabel(color(0,255,0))
		.setNumberOfTickMarks(25)
		.snapToTickMarks(true);
	       
	cp5.addKnob("colorblue") // right knob
		.setLabel("BLUE")
		.setRange(0, 255)
		.setValue(255)
		.setPosition(800,330)
		.setRadius(50)
		.setColorBackground(color(200))
		.setColorActive(color(0,0,colorblue,100))
		.setColorForeground(color(0,0,255,255))
		.setColorValueLabel(color(0,0,255))
		.setNumberOfTickMarks(25)
		.snapToTickMarks(true);
	
	cp5.addSlider("sliderValue")
		.setLabel("strokewight")
		.setRange(0, 25)
		.setValue(5)
		.setPosition(915, 30)
		.setSize(20, 200)
		.setColorValueLabel(color(0))
		.setColorCaptionLabel(color(255, 0, 0));
	
	 cp5.addSlider("alphaValue")
		.setLabel("alpha")
		.setRange(0, 255)
		.setValue(255)
		.setPosition(915, 250)
		.setSize(20, 200)
		.setColorValueLabel(color(0))
		.setColorCaptionLabel(color(255, 0, 0));
	
	 cp5.addButton("clear")
		.setLabel("ALL_CLEAR")
		.setPosition(825,520)
		.setSize(50,50)
		.setColorCaptionLabel(color(255, 0, 0))
		.setColorActive(color(10,0,0,255))
		.setColorForeground(color(0,0,255,200));
	
	cp5.addToggle("toggleValue")
		.setLabel("WHITE")
				.setSize(40, 20)
				.setPosition(825, 570)
				.setValue(false)
				.setColorCaptionLabel(color(0)) //テキストの色
				.setMode(ControlP5.SWITCH);
	
	cp5.addButton("black")
		.setLabel("BLACK")
		.setPosition(905,475)
		.setSize(50,50)
		.setColorCaptionLabel(color(255))
		.setColorActive(color(0,0,255))
		.setColorBackground(color(20))
		.setColorForeground(color(0));
	
	cp5.addButton("eraser")
		.setLabel("ERASER")
		.setPosition(905,530)
		.setSize(50,50)
		.setColorCaptionLabel(color(0))
		.setColorActive(color(0,0,255))
		.setColorBackground(color(255,255,255,200))
		.setColorForeground(color(255,255,255,255));
}

void draw() {
	if (lasttoggleValue == toggleValue) {
		fill(240);
		noStroke();
		rect(790, 0, 170, 600);
		nowcolor = color(colorred, colorgreen, colorblue,alphaValue);
		if (isdrag == 1) {
			  stroke(nowcolor);
			  strokeWeight(sliderValue);
			  line(bx, by, mouseX, mouseY);
			  bx = mouseX;
			  by = mouseY;
		} else{
			  stroke(0, 0, 100);
		}
		strokeWeight(1);
		stroke(0);
		fill(colorred, colorgreen, colorblue, alphaValue);
		rect(825, 450, 50, 50);
		noFill();
		ellipse(850, 475, sliderValue, sliderValue);
		lasttoggleValue = toggleValue;
	} else{
		lasttoggleValue = toggleValue;
		backgroundtoggle();
	}
}
void mousePressed() {
	if (mouseX <= mx) {
		   isdrag = 1;
		   bx = mouseX;
		   by = mouseY;
	}
}

void mouseReleased() {
	isdrag = 0;
}

void clear() {
	if (toggleValue == true) {
		background(255);
	} else {
		background(0,60,20);
	}
}

void backgroundtoggle() {
	if (toggleValue == true) {
		background(255);
	} else {
		background(0,60,20);
	}
}

void black() {
	colorred = 0;
	colorgreen = 0;
	colorblue = 0;
	alphaValue = 255;
}

void eraser() {
	if (toggleValue == true) {
		colorred = 255;
		colorgreen = 255;
		colorblue = 255;
		alphaValue = 255;
	} else {
		colorred = 0;
		colorgreen = 60;
		colorblue = 20;
		alphaValue = 255;
	}
	
}

