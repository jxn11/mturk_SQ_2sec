/**
 * Created by o-lab on 4/21/2017.
 */


var curTrial = 0;
var nTrials = 120;

var startTrialTime;

var lengthConds = [["30","60"],["60","120"],["120","240"],["240","480"],["480","960"],["960","1920"]];
var langConds = [["Eng","Eng"],["Eng","Kor"],["Kor","Kor"],["Kor","Eng"]];

var condOneCount = 0;
var condTwoCount = 0;
var condThreeCount = 0;
var condFourCount = 0;
var condFiveCount = 0;
var condSixCount = 0;

var case30count = 0;
var case60count = 0;
var case120count = 0;
var case240count = 0;
var case480count = 0;
var case960count = 0;
var case1920count = 0;

var fileName = [];

var trialCodes = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6];
