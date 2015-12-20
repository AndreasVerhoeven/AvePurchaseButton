# AvePurchaseButton
Drop In App Store Styled Purchase Button, with proper animations.

## Animations
A gif-movie showing how the button animates from normal to confirmation to in-progress state:
![Movie](https://cloud.githubusercontent.com/assets/168214/11920880/852741d6-a77a-11e5-839d-e2f572e49475.gif)


## Screenshot
A screenshot showing the different states of the button:
![Screenshot](https://cloud.githubusercontent.com/assets/168214/11920878/7c5d708e-a77a-11e5-8553-3806e89ba434.png)

## How to use
Create an instance of AvePurchaseButton. Set the normalTitle, confirmationTitle and handle UIControlEventTouchUpInside. To change states, use -[AvePurchaseButton setButtonState:animated:].

## Example usage:
```
- (void)addPurchaseButton {
  AvePurchaseButton* button = [[AvePurchaseButton alloc] initWithFrame:CGRectZero];
	[button addTarget:self action:@selector(purchaseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	button.buttonState = AvePurchaseButtonStateNormal;
	button.normalTitle = @"$ 2.99";
	button.confirmationTitle = @"BUY";
	[button sizeToFit];
	[self.view addSubview:button];
}

- (void)purchaseButtonTapped:(AvePurchaseButton*)button {
	switch(button.buttonState) {
		case AvePurchaseButtonStateNormal:
			[button setButtonState:AvePurchaseButtonStateConfirmation animated:YES];
			break;
			
		case AvePurchaseButtonStateConfirmation:
			// start the purchasing progress here, when done, go back to 
			// AvePurchaseButtonStateProgress
			[button setButtonState:AvePurchaseButtonStateProgress animated:YES];
			
			[self startPurchaseWithCompletionHandler:^{
			   [button setButtonState:AvePurchaseButtonStateNormal animated:YES];
			}];
			break;
			
		case AvePurchaseButtonStateProgress:
			break;
	}
}

```
