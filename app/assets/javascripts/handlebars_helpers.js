Handlebars.registerHelper('replyType', function(data){ 
    return data.data.root.postable.type == 'topic' ? 'posts' : 'replies';
  });