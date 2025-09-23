
 The first phase of a UVM testbench is the build phase. During this phase, the uvm_component classes
 that make up the testbench hierarchy are constructed into objects. The construction process 
 works top-down with eah level of the hierarchy constructed and configured before the next level
 down (sometimes also referred to as deferred construction).


 The UVM testbench is activated when the run_test() method is called in an intial block 
 of the HVL top level module. Each object is then construction using top down approach. 
 The various testbench component configuraion object are prepared and the virtual interfaces in t
 these configuration objects are assigned to the associated testbench interfaces.
 The configuraion objeccts are then nput into the UVM configuarion database. 
 Each level in the hierarchy has ability to retrieve and change the configuration data
 to guide the construction and configuration of the next level of hierarchy.

 After build phase connect phase make all inter-component connections. Contrary to the build phase
 the connect phase works buttom-up from the leafs to the top of the testbench hierarchy.

 
**The Test is the Starting Point for The Build Proess**
The build process for a UVM testbench starts form the test class and works top-down.
The test class build method is the first one called at the build phase. Its function is to 
• Set up any factory overrides so that configuration objects or component objects are created as derived types  as needed 
• Create and configure the configuration objects required by the various sub-components 
• Assign the virtual interface handles put into configuration space by the HDL testbench module 
• Build up an encapsulating env configuration object and include it into the configuration space 
• Build the next level down, usually the top-level env, in the testbench hierarchy

For a given verification environment most of the work done in the build method will be the same for all tests, and so it is recommended that a test base class is created which can be easily extended for each of the test cases. 


**Sub-Component Configuration Objects** 
Each grouping component like an agent or env should have a configuration object that defines its structure and 
behavior. These configuration objects should be created in the build method of the test and implemented to fit the requirements of the test case. If the configuration of a sub-component is either complex or likely to change, it is advised to add a virtual function implementing the basic (or default) configuration handling, which can then be overwritten in test cases extending from the base test class by overloading the virtual function.
