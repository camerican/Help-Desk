# Demo - Background Overlay

An example of adjusting the background opacity for an element without affecting the opacity of text within the element.

In our example, we'll want to have two overlapping elements; one to hold the text and another to hold the background image which will change opacity upon hover.  Rather than creating a second element, we'll use the `after` pseudo element to hold the background image.  This is advantageous because it allows us to stick with having a single element:

```html
<div class="item bg-one">
	Option One
</div>
<div class="item bg-two">
	Option Two
</div>
```

We apply two classes to each element; they'll all have the `.item` class while each one will have a different class for a unique background image.  We target the `::after` pseudo element on each `.item`:

```css
.item {
	width: 200px;
	height: 200px;
	display: inline-block;
	font-size: 20px;
	line-height: 200px;
	vertical-align: middle;
	padding: 20px;
	cursor: pointer;
	position: relative;
}
```

Each item will be 200px by 200px in this example.  We'll convert the `div`s from `block` to `inline-block` so that they stack side-by-side.  We'll specify a `line-height` of 200px (equal to the `height` of the element) which will vertically center the elements when we apply a `vertical-align` of `middle` -- providing that there is only one line of content.

The last important detail is that we set the `position` of `.item` to be `relative`.  Any child element (such as our `after` pseudo element!) that has a `position` of `absolute` will now be positioned relative to that non-static parent.  This allows us to stretch the `after` element across the entire container. 

```css
.item::after {
	content: '';
	position: absolute;
	top:0;
	bottom:0;
	right:0;
	left:0;
	z-index: -1;
}
```

We won't forget to place the `after` element behind the main `.item` element by setting its `z-index` to `-1`, one level behind the default of `0`.

Lastly, we'll want to change the opacity for the `after` element when we're hoving over the main element.

```
.item:hover::after {
	opacity: 0.5;
}
```
