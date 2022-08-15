## Stacked Steps

A widget that showcases progress through a succession of steps where successive steps are stacked over previous steps.

### Description

This package consists of widgets that can be used to compose a UI for displaying progress by stacking successive widgets over previous ones. 

#### 1. StackedStepsController

- A controller for the changing the progress from the provided steps.
- Can be used to build your own custom stacked steps widget.
- Provides API to go backwards at any point in the completed progress using [goBackAt].
- Can go forward using the [goNext] method by providing data that completes the current step.
- Steps can be changed using [changeSteps] method where steps must be more that 1.
- Provides [canGoBackAt], and [canGoNext] to check if the steps can be progressed forward or backwards.

#### 2. StackedSteps

- Provides an abstraction layer for showcasing progress through a succession of steps where successive steps are stacked over previous steps and every steps support supporting expand & collapse state which can be build using builders from [StepData].
- When the last widget is currently active, only the widget from last step is displayed representing completion of a progress. 
- In this widget, the provided steps are used in the progress in order of index i.e the first item is the first step and the last item is the last or final step. Atleast 2 steps must be provided where each step will get the value from previous completed step from [StackedStepsController.value.latestValue].
- Animates the appearance and disappearance of widget from the current step.

### Example

An minimal example is provided at `/example` directory.

### Screenshots

`/screenshots` directory
