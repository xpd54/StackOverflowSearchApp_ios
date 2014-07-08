//
//  QuestionTableViewCell.m
//  Stacky
//
//  Created by Ravi Prakash on 10/06/14.
//  Copyright (c) 2014 helpshift. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell {
    UILabel *_questionString;
    UILabel *_answerCountValue;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // Style for "Question Title" Text Label
        CGRect questionLabelRectangle = CGRectMake(120, -15, 90, 50);
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:questionLabelRectangle];
        questionLabel.textAlignment = NSTextAlignmentLeft;
        questionLabel.text = @"Question Title";
        questionLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:questionLabel];
        
        // Style for Question Title
        CGRect questionStringRectangle = CGRectMake(75, 20, 235,70);
        _questionString = [[UILabel alloc] initWithFrame:questionStringRectangle];
        _questionString.backgroundColor = [UIColor lightGrayColor];
        _questionString.numberOfLines = 0; // for multiple lines it will automatically handle
        [self.contentView addSubview:_questionString];
        
        //Style for "Ans Count" Text Label
        CGRect ansCountLabelRectangle = CGRectMake(5,-15,90,50);
        UILabel *ansCountLabel = [[UILabel alloc] initWithFrame:ansCountLabelRectangle];
        ansCountLabel.textAlignment = NSTextAlignmentLeft;
        ansCountLabel.text = @"Ans Count";
        ansCountLabel.font = [UIFont boldSystemFontOfSize : 12];
        [self.contentView addSubview:ansCountLabel];
        
        // Style for Ans count value
        
        CGRect ansCountValueRectangle = CGRectMake(5,20,70,70);
        _answerCountValue = [[UILabel alloc] initWithFrame:ansCountValueRectangle];
        _answerCountValue.backgroundColor = [UIColor greenColor];
        _answerCountValue.textAlignment = NSTextAlignmentCenter;
        _answerCountValue.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview : _answerCountValue];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setAnswerCount : (NSString *) ans {
    if(![ans isEqualToString:_answerCount]) {
        _answerCount = [ans copy];
        _answerCountValue.text = _answerCount;
    }

}

-(void) setQuestion : (NSString *) que {
    if(![que isEqualToString:_question]) {
        _question = [que copy];
        _questionString.text = _question;
    }
}

@end
