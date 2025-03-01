"
A MicMicrodownTextualBuilderTest is a test class for testing the behavior of MicMicrodownTextualBuilder
"
Class {
	#name : #MicMicrodownTextualBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'factory',
		'builder'
	],
	#pools : [
		'MicMicrodownSharedPool'
	],
	#category : #'Microdown-Tests-Builder'
}

{ #category : #'tests - codeblock' }
MicMicrodownTextualBuilderTest >> exampleMathTextMultipleLines [
	^ 'y = 3
x = 2 + y'
]

{ #category : #'tests - codeblock' }
MicMicrodownTextualBuilderTest >> exampleTextMultipleLines [
	^ 'Hello
Pharo'
]

{ #category : #running }
MicMicrodownTextualBuilderTest >> setUp [
	super setUp.
	factory := MicMicrodownSnippetFactory new.
	builder := Microdown builder
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testAnchor [

	self assert: (builder anchor: 'Anchor') contents equals:  AnchorMarkup, 'Anchor'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testAnchorReference [

	self 
		assert: (builder anchorReference: 'AnchorReference') contents 
		equals: AnchorReferenceOpenerMarkup, 'AnchorReference', AnchorReferenceCloserMarkup
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testAnnotated [

	self assert: (builder annotated: 'anAnnotation' paragraph:  [ builder text: 'anAnnotatedParagraph' ]) contents equals: '!!anAnnotation anAnnotatedParagraph', String cr
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testAnnotation [

	self 
		assert: (builder annotation: 'anAnnotationName' arguments: {'label'->'aLabel' . 'value' -> '42'} asDictionary) contents 
		equals: AnnotationOpenerMarkup,'anAnnotationName | label=aLabel&value=42', AnnotationCloserMarkup 
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testAnnotationNoArgs [

	self 
		assert: (builder annotation: 'anAnnotationName' arguments: {} ) contents 
		equals: AnnotationOpenerMarkup, 'anAnnotationName', AnnotationCloserMarkup
]

{ #category : #'tests - format' }
MicMicrodownTextualBuilderTest >> testBold [

	self assert: (builder bold: [builder text: 'Bold']) contents equals: '**Bold**'
]

{ #category : #tests }
MicMicrodownTextualBuilderTest >> testCell [

	self
		assert: (builder
		cell: [ 
			builder text: 'this is '.
			builder bold: [ builder text: 'bold' ] ]) contents
		equals: '| this is **bold** '
]

{ #category : #'tests - codeblock' }
MicMicrodownTextualBuilderTest >> testCodeBlock [

	"```language2=Pharo&caption=`Color` is cool
	Hello
	Pharo
	```"

	| mictext |
	mictext := builder
		           codeblock: self exampleTextMultipleLines
		           firstLineAssociations: { 
				           ('language2' -> 'Pharo') };
		           contents.
	self 
		assert: mictext 
		equals: 
'```language2=Pharo
', self exampleTextMultipleLines, 

'
```
'

]

{ #category : #'tests - codeblock' }
MicMicrodownTextualBuilderTest >> testCodeBlockCaptionContainsMonospace [

	"```language2=Pharo&caption=`Color` is cool
	Hello
	Pharo
	```"

	| mictext |
	mictext := builder
		           codeblock: self exampleTextMultipleLines
		           firstLineAssociations: { 
				           ('language2' -> 'Pharo').
				           ('caption' -> '`Color` is cool') }
					  withCaption: [ builder text: '`Color` is cool' ];
		           contents.
	self 
		assert: mictext 
		equals: 
'```language2=Pharo&caption=`Color` is cool
', self exampleTextMultipleLines, 

'
```
'

]

{ #category : #'tests - slides' }
MicMicrodownTextualBuilderTest >> testColumns [

	self 
		assert: (builder 
					columnsWithBody: [ builder text: 'This is a paragraph in a columns'] ) contents 
		equals: '<!columns|width=100

This is a paragraph in a columns
!>
'
]

{ #category : #'tests - slides' }
MicMicrodownTextualBuilderTest >> testColumnsWithChildren [

	self 
		assert: (builder 
						columnsWithBody: [ builder 
													columnWidth: '60' 
													withBody: [ builder text: 'This is a paragraph in a column']] ) contents 
		equals: '<!columns|width=100

<!column|width=60

This is a paragraph in a column
!>


!>
'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testComment [

	self assert: (builder comment: 'Comment') contents equals: CommentedLineMarkup, ' Comment'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testEnvironment [

	self 
		assert: (builder environment: 'anEnvironmentName' arguments: {'label'->'aLabel' . 'value' -> '42'}) contents 
		equals: '<!anEnvironmentName|label=aLabel&value=42
!>'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testEnvironmentWithBody [

	self 
		assert: (builder environment: 'anEnvironmentName' 
					body: [ builder text: 'aText'] 
					arguments: {'label'->'aLabel' . 'value' -> '42'}) contents 
		equals: '<!anEnvironmentName|label=aLabel&value=42
aText
!>'
]

{ #category : #'tests - references' }
MicMicrodownTextualBuilderTest >> testExternalLink [

	self 
		assert: (builder externalLink: 'anUrl' withDescription: [ builder text: 'aDescription'] ) contents 
		equals: '[aDescription](anUrl)'
]

{ #category : #'tests - references' }
MicMicrodownTextualBuilderTest >> testExternalLinkWithBold [

	self 
		assert: (builder externalLink: 'anUrl' withDescription:[ builder bold: [ builder text: 'aDescription']] ) contents 
		equals: '[**aDescription**](anUrl)'
]

{ #category : #'tests - references' }
MicMicrodownTextualBuilderTest >> testExternalLinkWithItalic [

	self 
		assert: (builder externalLink: 'anUrl' withDescription:[ builder italic: [ builder text: 'aDescription']] ) contents 
		equals: '[_aDescription_](anUrl)'
]

{ #category : #'tests - references' }
MicMicrodownTextualBuilderTest >> testExternalLinkWithMonospace [

	self 
		assert: (builder externalLink: 'anUrl' withDescription: [ builder monospace: 'aDescription'] ) contents 
		equals: '[`aDescription`](anUrl)'
]

{ #category : #'tests - references' }
MicMicrodownTextualBuilderTest >> testExternalLinkWithNested [

	self 
		assert: (builder externalLink: 'anUrl' withDescription:[ builder bold: [ builder italic: [ builder text: 'aDescription']]] ) contents 
		equals: '[**_aDescription_**](anUrl)'
]

{ #category : #'tests - references' }
MicMicrodownTextualBuilderTest >> testExternalLinkWithStrike [

	self 
		assert: (builder externalLink: 'anUrl' withDescription:[ builder strike: [ builder text: 'aDescription']] ) 
		contents equals: '[~aDescription~](anUrl)'
]

{ #category : #'tests - figure' }
MicMicrodownTextualBuilderTest >> testFigureInPresenceOfParagraph [
	| dictionnary |
	dictionnary := {'label'->'aLabel' . 'size'->'80'} asOrderedDictionary.
	self 
		assert: (builder 
							root: [ builder paragraph: [ builder text: 'This is some text forming a paragraph and then there is figure.' ].
									builder 
										figureURLString: 'http://www.pharo.org/files/ouf.png' 
										withCaption: [ builder text: 'it is a beautifull figure'] 
										withParameters:  dictionnary ] ;				
							contents) contents 
		equals: 'This is some text forming a paragraph and then there is figure.
![it is a beautifull figure](http://www.pharo.org/files/ouf.png label=aLabel&size=80)'
]

{ #category : #'tests - figure' }
MicMicrodownTextualBuilderTest >> testFigureWithBold [

	self 
		assert: (builder 
						figureURLString: 'http://www.pharo.org/light.jpeg' 
						withCaption: [ builder text: 'it is a';  bold: [ builder text:'beautifull']; text: 'figure' ];				
							contents) contents 
		equals: '![it is a**beautifull**figure](http://www.pharo.org/light.jpeg)'
]

{ #category : #'tests - figure' }
MicMicrodownTextualBuilderTest >> testFigureWithParameters [
	| dictionnary |
	dictionnary := {'label'->'aLabel' . 'size'->'80'} asOrderedDictionary.
	self 
		assert: (builder 
							figureURLString: 'http://www.pharo.org/flo.png' 
							withCaption: [builder text: 'it is a beautifull figure'] 
							withParameters:  dictionnary;				
							contents) contents 
		equals: '![it is a beautifull figure](http://www.pharo.org/flo.png label=aLabel&size=80)'
]

{ #category : #tests }
MicMicrodownTextualBuilderTest >> testHeadCell [
	self assert: builder headCell contents equals: '| --- '
]

{ #category : #'tests - header' }
MicMicrodownTextualBuilderTest >> testHeaderWithItalic [

	self 
		assert: (builder 
							header: [ builder text: 'Hello ';
											 italic: [ builder text: 'Pharo' ];
											 text: ' is cool']  withLevel: 1;				
							contents) contents 
		equals: HeaderMarkup , ' Hello _Pharo_ is cool
'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testHorizontalLine [

	self 
		assert: builder horizontalLine contents 
		equals: HorizontalLineMarkup, String cr
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testInputfile [

	self 
		assert: (builder inputFile: 'Chapters/image.png') contents 
		equals: '
',EnvironmentOpeningBlockMarkup ,'inputFile|path=Chapters/image.png', EnvironmentClosingBlockMarkup 
]

{ #category : #'tests - format' }
MicMicrodownTextualBuilderTest >> testItalic [

	self assert: (builder italic: [ builder text: 'Italic' ]) contents equals: '_Italic_'
]

{ #category : #'tests - codeblock' }
MicMicrodownTextualBuilderTest >> testMathBlockCaptionContainsMonospace [

	"```language2=Pharo&caption=`Color` is cool
	Hello
	Pharo
	```"

	| mictext |
	mictext := builder
		           mathblock: self exampleMathTextMultipleLines
		           firstLineAssociations: { 
				           ('label' -> 'Math').
				           ('caption' -> '`Math` is cool') }
					  withCaption: [ builder text: '`Math` is cool'];
		           contents.
	self 
		assert: mictext 
		equals: 
MathOpeningBlockMarkup, 'label=Math&caption=`Math` is cool
', self exampleMathTextMultipleLines, String cr, MathClosingBlockMarkup , String cr
"Bad idea to hardcode String cr"

]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testMathInline [

	self assert: (builder mathInline: 'x = 2 + y') contents equals: '$x = 2 + y$'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testMetaData [

	self 
		assert: (builder metaDataFromAssociations: {'label'->'aLabel' . 'size'->'142'}) contents 
		equals: MetaDataOpeningBlockMarkup , String cr ,'"label" : "aLabel",' , String cr, '"size" : "142"', String cr , MetaDataClosingBlockMarkup
]

{ #category : #'tests - format' }
MicMicrodownTextualBuilderTest >> testMonospace [

	self assert: (builder monospace: 'Monospace') contents equals: '`Monospace`'
]

{ #category : #'tests - slides' }
MicMicrodownTextualBuilderTest >> testOneColumn [

	self 
		assert: (builder 
					columnWidth: '60' 
					withBody: [ builder text: 'This is a paragraph in a column'] ) contents 
		equals: '<!column|width=60

This is a paragraph in a column
!>

'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testOrderedListDuring [

	self 
		assert: (builder orderedListDuring: [  {'item1' . 'item2' . 'item3' } 
							do: [ :each | builder 
												orderedItem: [ builder text: each] ] ]) contents
		equals: '1. item1
1. item2
1. item3
'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testParagraph [

	self assert: (builder paragraph: [ builder text: 'aParagraph' ]) contents equals: 'aParagraph', String cr
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testQuoteBlock [

	self assert: (builder quoteBlock: 'aQuote') contents equals: PreformattedMarkup, ' aQuote'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testRawFormat [

	self assert: (builder rawFormat: 'aRawFormat') contents equals: RawOpenerMarkup, 'aRawFormat', RawCloserMarkup
]

{ #category : #tests }
MicMicrodownTextualBuilderTest >> testRawParametersWithNotStringAtValue [
	
	builder rawParameters: { 'label'->42 . 'size'->MicTextBlock } asDictionary.
	self assert: builder contents equals: 'label=42&size=MicTextBlock'
]

{ #category : #'tests - slides' }
MicMicrodownTextualBuilderTest >> testSimpleSlide [

	self 
		assert: (builder 
					slideTitle: 'Ze super cool slide' 
					withBody: [ builder text: 'This is a paragraph in a slide'] ) contents 
		equals: '<!slide|title=Ze super cool slide

This is a paragraph in a slide
!>
'
]

{ #category : #'tests - format' }
MicMicrodownTextualBuilderTest >> testStrike [

	self assert: (builder strike: [ builder text: 'Strike']) contents equals: '~Strike~'
]

{ #category : #'tests - format' }
MicMicrodownTextualBuilderTest >> testStrikeInHeader [
	
	self assert: (builder 
							header: [ builder 
											text: 'Hello ';
											strike: [ builder text: 'Pharo' ]; 
											text: ' is cool']  withLevel: 1;				
							contents)
			equals: '# Hello ~Pharo~ is cool
'
]

{ #category : #'tests - anchor' }
MicMicrodownTextualBuilderTest >> testUnorderedList [

	self 
		assert: (builder unorderedListDuring: [  {'item1' . 'item2' . 'item3' } do: [ :each | builder item: [ builder text: each] ] ]) contents
		equals: '- item1
- item2
- item3
'
]
