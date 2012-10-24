public class PFrame extends Frame {
    public SecondaryApplet s;  
    public int w,h;
  
    public PFrame() {
        setBounds(0,0,800,200);
        w=800;
        h=200;
        
        s = new SecondaryApplet(800,200);
        add(s);
        s.init();
        
        show();
    }
    
    public PFrame(String name) {
        this();
        this.setTitle(name);
    }
   
}

