define 'SharedExamples', ['interface'], (Interface)->
  {
    expects_it_like_behaviour_from: (name)->
      str = """
        describe("##{name}", function(){
            var args,
                subject,
                JasmineMock,
                WrapperMock,
                ArgsWrapperMock
                original_function = function() {},

          beforeEach(function(){
            WrapperMock     = jasmine.createSpyObj('WrapperMock', ['it', 'iit']);
            ArgsWrapperMock = jasmine.createSpy('ArgsWrapperMock').and.returnValue(WrapperMock);
            JasmineMock     = jasmine.createSpyObj('JasmineMock', ['it', 'iit', 'fit', 'xit']);
            subject         = new Interface(JasmineMock, ArgsWrapperMock);
            args = [ original_function ];
            subject.#{name}.apply(this, args);
          });

          it("should call jasmine.#{name} function", function(){
            expect(JasmineMock.#{name}).toHaveBeenCalled()
            expect(JasmineMock.#{name}.calls.count()).toBe(1)
          });

          it("should call ArgsWrapper", function(){
            expect(ArgsWrapperMock).toHaveBeenCalled()
            expect(ArgsWrapperMock.calls.count()).toBe(1)
            expect(ArgsWrapperMock.calls.argsFor(0)).toEqual(args)
          });

          it("should call WrapperMock.it", function(){
            expect(WrapperMock.it).toHaveBeenCalled()
            expect(WrapperMock.it.calls.count()).toBe(1)
            expect(WrapperMock.it.calls.argsFor(0).length).toBe(0)
          });
        });
      """
      eval str, this
  }
