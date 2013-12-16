Expandable-Collapsable-TableView
================================

This sample project shows how to implement Expandable/Collapsable TableView in iOS. This Project expands and collapses table view cells on selecting a cell or row of table or by tapping on a button on the cell in tableview. 

The project is implemented using Storyboards and is iOS7 compatible.

The project is easily customizable. You can choose expand/collpase the tableview either by selecting a row or by tapping on the button in the row. If you want to use selection of row to expand the table then just delete the method:

    -(void)showSubItems : (id) sender
    
If you want to use button to expand/collapse rows then just remove the code from didSelectRowAtIndexPath method and you can implement your own code in it.


