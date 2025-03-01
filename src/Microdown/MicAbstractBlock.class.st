"
I am the abstract node of the block objects generated by `MicroDownParser`.

The root of the parsetree is an instance of `MicRootBlock`.
I have a set of children, and an uplink to my parent.

See the comment of `MicroDownParser` for an overview of the algorithm used in building such parse tree.
"
Class {
	#name : #MicAbstractBlock,
	#superclass : #MicElement,
	#instVars : [
		'children',
		'parser'
	],
	#category : #'Microdown-Model'
}

{ #category : #public }
MicAbstractBlock class >> alternateBlockClassFor: line [
	"This hook supports extensions of environments. 
	we get <?slide ... and we do not create an environment but a slideBlock"
	^ self
]

{ #category : #adding }
MicAbstractBlock >> addChild: childBlock [
	children add: childBlock
]

{ #category : #public }
MicAbstractBlock >> addLineAndReturnNextNode: line [
	"add line to this node. 
	Notice, the action is allowed to create new nodes in the block tree.
	Returns the node to handle next line - typically self."

	self subclassResponsibility.
	^ self
]

{ #category : #public }
MicAbstractBlock >> blockExtensionStarterClassFrom: line [
	"return the class of a block which can start with line, or nil if none"

	^ nil
]

{ #category : #public }
MicAbstractBlock >> blockStarterClassFrom: line [
	"return the class of a block which can start with line, or nil if none"

	^ (self parser blockStarterClassFrom: line) ifNotNil: [ :c | c alternateBlockClassFor: line ]
]

{ #category : #public }
MicAbstractBlock >> canConsumeLine: line [
	"return if this block can consume line"

	^ self subclassResponsibility 
]

{ #category : #adding }
MicAbstractBlock >> children [
	^children 
]

{ #category : #adding }
MicAbstractBlock >> children: aCollection [
 	children := aCollection
]

{ #category : #public }
MicAbstractBlock >> closeMe [
	"I'm hook for closing elements. By default do nothing."
	
	^ self
]

{ #category : #public }
MicAbstractBlock >> computeNestedLevel [ 

	^ 0
]

{ #category : #properties }
MicAbstractBlock >> hasProperty: aKey [
	"Test if the property aKey is present."
	
	^ self properties notNil and: [ self properties includesKey: aKey ]
]

{ #category : #accessing }
MicAbstractBlock >> indent [
	^ parent indent
]

{ #category : #initialization }
MicAbstractBlock >> initialize [
	super initialize. 
	children := OrderedCollection new.
]

{ #category : #'*Microdown-DocumentBrowser' }
MicAbstractBlock >> isRootSection [ 
	^ false
]

{ #category : #testing }
MicAbstractBlock >> listItemBlockClass [
	^ MicListItemBlock
]

{ #category : #public }
MicAbstractBlock >> nestedLevel [ 
	"Return the nesting level of main blocks. Basically only list increases this."
	
	^ 0
]

{ #category : #public }
MicAbstractBlock >> newBlockFor: line parent: parentBlock [
	| newBlockClass |
	newBlockClass := self blockStarterClassFrom: line.
	newBlockClass ifNil: [ ^parentBlock ].
	^ newBlockClass new
		setParser: parser;
		parent: parentBlock;
		addLineAndReturnNextNode: line
]

{ #category : #private }
MicAbstractBlock >> parser [
	^ parser 
]

{ #category : #private }
MicAbstractBlock >> parserClass [ 
	^ MicrodownParser
]

{ #category : #replacement }
MicAbstractBlock >> replace: aBlock by: anotherBlock [ 
	
	children replaceAll: aBlock with: anotherBlock 
]

{ #category : #replacement }
MicAbstractBlock >> replace: aBlock byCollection: aCollection [ 
	
	children := children copyReplaceAll: {aBlock} with: aCollection 
]

{ #category : #replacement }
MicAbstractBlock >> replaceBy: anotherBlock [ 
	self parent replace: self by: anotherBlock
]

{ #category : #replacement }
MicAbstractBlock >> replaceByAll: aCollection [ 
	self parent replace: self byCollection: aCollection 
]

{ #category : #private }
MicAbstractBlock >> setParser: aParser [
	parser := aParser 
]

{ #category : #accessing }
MicAbstractBlock >> text [
	| text |
	self flag: #todo.
	"what a terrible idea we concatenate the text of children and store. 
	I could understand that we keep the text of the parser element but then we do not modify it after
	and certainly not change it."
	text := ''.
	children do: [ :each | text := text , each text ].
	^ text
]
