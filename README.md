

##<a name="dishwasher-app">Dishwasher App</a>
John Lewis Partnership **iOS Developer** Technical Test

![Screenshot of product details](README/Details1.png)  


##<a name="intro">Intro</a>
Hi there.

The repository contains my John Lewis Partnership iOS Developer Technical Test. Please feel free to get in touch with any questions or queries you may have. I will be more than happy to get back to you as soon as possible. 

<matthewpharding@gmail.com> 

In the meantime, hopefully this README file will tell you all you need to know.
🙂
 

##<a name="requirements">Requirements</a>
 
* The App should work on an iPad, in landscape and portrait mode.
	* The DishwasherApp is an **iPad** only app, working in all orientations. 

	
![Screenshot of product details](README/Details2.png)  ![Screenshot of product details](README/Details3.png)  

* The code should be written in Objective-C, Swift or both.
	* The code is written in **Swift 3.0**.
* The use of third party Code/SDKs is allowed, but you should be able to explain why you have chosen the third party.
	* Third party libraries have been using using the CocoaPods dependancy manager for two small purposes.
		1. Local **image caching**. [Kingfisher](#third-party-library-kingfisher)
		2. **JSON parsing** library. [Argo](#third-party-library-argo)

* We’d like to see a TDD approach to writing the app.
	* **Test Driven Development** has been utilised to design the architecture and generate testable chunks of code, also encapsulating any business logic. 

* When submitting your app to us, we expect the code to build and run using the latest version of Xcode that is currently available in the Apple App Store.
	* The project was created usiing the latest version of Xcode **Version 8.2.1 (8C1002)**.
* Committing your code constantly to a GitHub Account.
	* a ```GitHub``` account has been used alongside ```GitFlow``` as a branching strategy.
* Putting all your assumptions, notes and instructions into your GitHub README.md
	* All asumptions are outlined within the [Assumptions](#assumptions) section below.


##<a name="the-approach">The Approach</a>

> We’re not looking for a ‘pixel perfect’ app, we are looking at your style of coding, and how you’ve approached this.

####UI

Taking the structure of the test into consideration the architecure has maintained the focus together with structuring the core logic of the application. The visual layer behaves as expected with an additional loading/ rety state for failed requests. Any minor differences with the attached wireframes/ designs are intensional and outlined in the [Assumptions](#assumptions) section.

####TTD Driving the Design

Tests were created before and alongside the development driving the architecture and class hierarchy, (although in this case we favour structs over classes) providing and ensuring strong dependancy injection, loose coupling, high cohesion with a testable design. 

####Protocols

Protocols offer a contract without the knowledge of any concrete implementations and have been key in the flexibility and testability of this project.

####Seperating out the Presentation Layer
The logic has been seperated out into two main areas

1. **The core logic**
2. **The presentation layer**

		
An iOS application is no longer confined to one platform. TVOS, Applewatch and other key extensions will likely share the same core components. For this reason and future expansion we must ensue this seperation exists from our initial implementation. 
**The core logic** will encapsulate and centralise the logic to communicate with services specific to the product and not the device.
**The presentation** will restrict itself to the visual representation of the data provided by the underlying system.


####Layered Architecture

	Presentation
	Feature
	Product API
	Parsing
	Networking
	URL Requests

A strict set of layers has been implemented to maintain clear abstraction and seperation of reposnisbilities. In the event of these layers requiring large refactoring the task will remain relatively painless as each layer is properly confined. Each piece of data has been processed and passed up the levels with new error types and their own manipulation. The only exception being the models which have been kept to the same type merely for the sake of simplicity in this coding test.

####Product API -  Dishwasher or Toaster?
Although the test is geared towards dishwasher appliances, the architectural layout and design has ben structured towards a search api which will return a list of products. Without the use of a search bar the ```SearchViewController``` has been hard coded with a search term that can be easily changed.

####Documentation - Code Documenting Itself 
As you will see throughout the project, code comments have been kept to a minimum allowing the swift syntax and descriptive naming to document them selves. This approach reduces future over head and will irradicate out of date comments no longer relevant to their current context. 

####Storyboards, segues and .xibs 
As you know storyboards have several advantages and can be a real pleasure to work with. The overall navigation view, rapid development speed and use of container views (to name a few) are especially a real benefit. However, there are also some limitations such as prototypes cell reuse and cognative overload with complicated layouts. For this reason I have utilsed the benefit of both tools, implementing storyboards for their descriptive navigational overview and use of container views aiding more complex embedded behaviours and implementing .xib files for tableview cells for re-use and to prevent long lists of embedded prototype cells cluttering the storyboard scene. 


## <a name="third-party-library">Third Party Libraries</a>

![Cocoa Pods Icon](README/CocoaPodsLogo.png)    ![Cocoa Pods Icon](README/Cocoapods.jpg)

###<a name="third-party-library-argo">Argo</a> *JSON Parser* 	
<https://cocoapods.org/pods/Argo>

Rather than writing verbose and complicated parsing algorithms for data constructed in the JSON format I have added a librray to. the project, which is widely used ini the iOS community. This addition to the code base will provide a proven approach to mapping JSON data to model objects, save development time and ensure a structured aligned process is applied to converting this data rather than directly parsing this ourselves

###<a name="third-party-library-kingfisher">Kingfisher</a> *Image Caching*	
<https://cocoapods.org/pods/Kingfisher>

A common approach on mobile is to introduce a local caching strategy for image data, where we can keep the assets stored locally for a small period o time. This will lower networking calls, increase performance and enhance the user experience by ensuring pleasing artwork is available as quickly as possible. I have introduced a library for this section of the test for the same reasons whist focussing spare development time on the core logic of the project.

## <a name="assumptions">Assumptions/ Notes</a>

####Product Information Format
The format of this property (within the product detail response) is HTML when other implemented values were all receieved in plain text. As the design screenshots do not suggest HTML was implemented as a concious design choice, I have cleaned the data removing any HTML formatting and adding consistency with the design.

####Design Screenshots as a Guide
Although the final implementation matches the design screenshots to a high degree there are some differences. Such as the **Read More** option which would be displayed when the description would span over a maximum height (as far as I understand from the screenshot). This functionality would not be difficult to implement, however as it was not mentioned within the requirements or specification I have used any extra time I had to focus on the approach.

The padding of the tablview cell imageviews and tableview line breaks also differ slightly from the design. Again, this is an intentional choice and  

####Retry Feature 
I have added the ability to recover from a failed network request on both screens. Although this functionality works well, it has been added for completeness and as a precaution in the event that a **test reviewer** may have a lossy data connection. I am aware that this feature could be refined further.
