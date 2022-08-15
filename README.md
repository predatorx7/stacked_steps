## Stacked Steps

A widget that showcases progress through a succession of steps where successive steps are stacked over previous steps.

### Description

This package consists of widgets that can be used to compose a UI for displaying progress by stacking successive widgets over previous ones. Latest release available at https://github.com/predatorx7/stacked_steps/releases/latest

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
A very simple example to demonstrate a sample usage of the stacked steps library.

### Screenshots

`/screenshots` directory

![Stacked Steps | Step 1](https://raw.githubusercontent.com/predatorx7/stacked_steps/5097a4258e6736226fc6212a7ba3cb3a4fddb7ea/screenshots/step_1.png)

![Stacked Steps | Step 2](https://raw.githubusercontent.com/predatorx7/stacked_steps/5097a4258e6736226fc6212a7ba3cb3a4fddb7ea/screenshots/step_2.png)

![Stacked Steps | Step 3](https://raw.githubusercontent.com/predatorx7/stacked_steps/5097a4258e6736226fc6212a7ba3cb3a4fddb7ea/screenshots/step_3.png)

![Stacked Steps | Step 4](https://raw.githubusercontent.com/predatorx7/stacked_steps/5097a4258e6736226fc6212a7ba3cb3a4fddb7ea/screenshots/step_4_idle.png)

![Stacked Steps | loading on Step 4](https://raw.githubusercontent.com/predatorx7/stacked_steps/5097a4258e6736226fc6212a7ba3cb3a4fddb7ea/screenshots/step_4_loading.png)

![Stacked Steps | Final Step](https://raw.githubusercontent.com/predatorx7/stacked_steps/5097a4258e6736226fc6212a7ba3cb3a4fddb7ea/screenshots/step_5_idle.png)

